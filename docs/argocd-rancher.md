# How to register Rancher managed Kubernetes clusters in Argo CD

Registering Rancher managed clusters in Argo CD doesn't work out of the box unless the [Authorized Cluster Endpoint](https://rancher.com/docs/rancher/v2.x/en/cluster-admin/cluster-access/ace) is used. Many users will prefer an integration of Argo CD via the central Rancher authentication proxy (which shares the network endpoint of the Rancher API/GUI). So let's find out why registering clusters via Rancher auth proxy fails and how to make it work.    

*Hint: If you are just looking for the solution scroll to the bottom of this page.*

## Why do i get an error when running `argocd cluster add`?

### Service Account tokens and the Rancher authentication proxy

Registering external clusters to an Argo CD instance is normally accomplished by invoking the command-line tool `argocd` [like this](https://argoproj.github.io/argo-cd/getting_started/#5-register-a-cluster-to-deploy-apps-to-optional):

```shell
$ argocd cluster add <context-name>
```

Here, `context-name` references a context in the command-line user's kubeconfig file (by default `~/.kube/config`).    
Running this command using a context that points to a Rancher authentication proxy endpoint (typically an URL in the form `https://<rancher-server-endpoint>/k8s/clusters/<cluster-id>`) will result in the following error:

```
FATA[0001] rpc error: code = Unknown desc = REST config invalid: the server has asked for the client to provide credentials 
```

*Ref: [GH ticket](https://github.com/argoproj/argo-cd/issues/1237)*

Before getting to the solution let's understand why this happens.

By default, the kubeconfig files provided by Rancher specify the Rancher server network endpoint as the cluster API `server` endpoint. By doing so Rancher acts as an authentication proxy that validates the user identity and then proxies the request to the downstream cluster.

This generally has a number of advantages compared to having clients communicating directly with the downstream cluster API endpoint:One of the is that this  provides a high available Kubernetes API endpoint for *all clusters* under Rancher's management, sparing the ops team from having to maintain a failover/load-balancing mechanism for each cluster's API servers.    
An alternative authentication method avalaible in Rancher is the Authorized Cluster Endpoint which allows requests to be authenticated directly at the downstream cluster Kubernetes API server. [See the documentation](https://rancher.com/docs/rancher/v2.x/en/cluster-admin/cluster-access/ace) for details on these methods.    

It is important to understand that **only the Authorized Cluster Endpoint allows authentication based on K8s service account tokens**. The authentication proxy endpoint requires usng a Rancher API token instead.

## How can still use the central Rancher auth endpoint to integrate ArgoCD

To summarize: In order to integrate Argo CD via the Rancher server network endpoint, we will need to setup Argo CD with a Rancher API token in lieu of a Kubernetes Service Account token.   

For now this can not be accomplished using the `argocd` command-line tool because it doesn't let the user specify a pre-existing API credential or custom `kubeconfig`.     

Luckily, `argocd` is at the core just a Kubernetes client with syntactic sugar coating and therefore does most things by interacting with Kubernetes (CRD) resources under the hood. So whatever `$ argocd cluster add` does, we should be able to do this using `kubectl` and K8s manifests.

According to the [documentation](https://argoproj.github.io/argo-cd/getting_started/#5-register-a-cluster-to-deploy-apps-to-optional) the "cluster add" command does the following:     

> The above command installs a ServiceAccount (argocd-manager), into the kube-system namespace of that kubectl context, and binds the service account to an admin-level ClusterRole. Argo CD uses this service account token to perform its management tasks (i.e. deploy/monitoring).

And in [another place](https://argoproj.github.io/argo-cd/operator-manual/security/#external-cluster-credentials) we find:

> To manage external clusters, Argo CD stores the credentials of the external cluster as a Kubernetes Secret in the argocd namespace. This secret contains the K8s API bearer token associated with the argocd-manager ServiceAccount created during argocd cluster add, along with connection options to that API server

Futhermore, the format of that cluster secret is also described in detail [on this page](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#clusters) providing the following example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mycluster-secret
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: mycluster.com
  server: https://mycluster.com
  config: |
    {
      "bearerToken": "<authentication token>",
      "tlsClientConfig": {
        "insecure": false,
        "caData": "<base64 encoded certificate>"
      }
    }
```

Finally, the `argocd` CLI creates a RBAC role called `argocd-manager-role` which by default assigns clusteradmin privileges but [can be narrowed down](https://argoproj.github.io/argo-cd/operator-manual/security/#cluster-rbac) to implement a least-privilege concept.

### tl;dr: Here are the steps to register Rancher managed clusters using the central Rancher API endpoint

So it appears that all we need to do is replace the `argocd cluster add` command with the following steps:

1. Create a local Rancher user account (e.g. `service-argo`)
2. Create a Rancher API token for that user account, either by logging in and using the GUI (API & Keys -> Add Key) or requesting the token via direct invocation of the `/v3/tokens` API resource.
3. Authorize that user account in the cluster (GUI: Cluster -> Members -> Add) and assign the `cluster-member` role (role should be narrowed down for production usage later).
4. Create a secret resource file (e.g. cluster-secret.yaml) based on the example above, providing a configuration reflecting the Rancher setup:
    - `name`: A named reference for the cluster, e.g. "prod".
    - `server`: The Rancher auth proxy endpoint for the cluster in the format: `https://<rancher-server-endpoint>/k8s/clusters/<cluster-id>`
    - `config.bearerToken`: The Rancher API token created above
    - `config.tlsClientConfig.caData`: PEM encoded CA certificate data for Rancher's SSL endpoint. Only needed if the server certificate is not signed by a public trusted CA.
5. Then apply the secret to the Argo CD namespace in the cluster where Argo CD is installed (by default `argocd`):
    `$ kubectl apply -n argocd -f cluster-secret.yaml`
    
Finally check that the cluster has been successfully registered in Argo CD:

```sh
argocd cluster list
SERVER                                                     NAME     VERSION  STATUS      MESSAGE
https://xxx.rancher.xxx/k8s/clusters/c-br1xm               vsphere  1.17     Successful
https://kubernetes.default.svc                                               Successful
```