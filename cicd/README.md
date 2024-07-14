# CICD

This folder contains the configuration for the CI/CD pipeline. I use Terraform to bootstrap Flux in the kubernetes cluster. The Flux will then deploy the resources, such as Ingress, LoadBalancer, CSI, and the applications themselves. The applications are stored in the `apps` folder. Core components are stored in the `core` folder.

## Steps

```bash

# Place the kubeconfig to access the cluster inside the cicd folder
cd cicd/terraform

# Install necessary resources
terraform init
terraform apply # confirm the plan
```
