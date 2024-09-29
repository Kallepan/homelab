# Kubernetes

## Flux CICD

Init command

```bash
flux bootstrap git --url=ssh://git@github.com/kallepan/homelab.git --branch=main --private-key-file=keys/github_key --path=cicd/prod --kubeconfig=terraform/prod/files/kubeconfig.yaml
```

## Kubespray

```bash
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
```

## Rancher

### Validating webhook fails

If deleting the cattle-system is stuck in terminating state. You need to delete the `rancher.cattle.io` resource of type `Validatingwebhookconfigurations` to unblock the deletion of the namespace. Afterwards the finalizers can be removed from the namespace using `kubectl edit namespace cattle-system`.

```bash
alias k='sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf'
k get validatingwebhookconfigurations -A
k delete validatingwebhookconfigurations <name>

k get namespace cattle-system -o json | jq '.spec.finalizers = []' | sudo kubectl --kubeconfig /etc/kubernetes/admin.conf replace --raw /api/v1/namespaces/cattle-system/finalize -f -
```

This was taken from [this](https://github.com/rancher/rancher/issues/41826#issuecomment-1633681415) issue.
