# Mibi K8s

## Description
Create a namespace and user for the mibi group. The user should have access to the namespace and be able to create pods, services, and deployments. The user should not have access to any other namespaces or resources. The user should be able to access the cluster using kubectl by using the kubeconfig file.

## Prerequisites

- kubectl
- kubeconfig to existing cluster
- variables defined in the bash script:
    - `NAMESPACE`
    - `SERVICE_ACCOUNT`
    - `SERVER`
    - `ADMIN_KUBE_CONFIG`
    - `OUTPUT_KUBE_CONFIG`