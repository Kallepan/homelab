# Kubernetes RBAC

## Description
Create a namespace and user for a given group. The user should have access to the namespace and be able to create pods, services, and deployments. The user should not have access to any other namespaces or resources. The user should be able to access the cluster using kubectl by using the kubeconfig file.

## Prerequisites

- kubectl
- kubeconfig to existing cluster
- variables defined in the bash script:
    - `NAMESPACE` - the name of the namespace
    - `SERVICE_ACCOUNT` - the name of the service account
    - `SECRET_NAME` - the name of the secret e.g. token
    - `SERVER` - the server address for the cluster
    - `CLUSTER_NAME` - the name of the cluster as defined in the admin config
    - `ADMIN_KUBE_CONFIG` - the kubeconfig file for the admin
    - `OUTPUT_KUBE_CONFIG` - the kubeconfig file for the user