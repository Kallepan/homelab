# Terraform

Terraform is an open-source infrastructure as code software tool created by HashiCorp. Users define and provide data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language (HCL), or optionally JSON.

I use it in my homelab to manage my infrastructure.

## Folders

- `rancher` - Terraform code to manage Rancher server and agents
- `clustertemplate` - Terraform module to manage cluster infrastructure
- `cluster-prod` - Terraform code to manage production cluster infrastructure
- `gitlab` - Terraform code to manage Gitlab server

## Usage

```bash

cd <path-to-terraform-subdirectory>
terraform init
terraform plan -var-file=secret.tfvars
terraform apply -var-file=secret.tfvars
```
