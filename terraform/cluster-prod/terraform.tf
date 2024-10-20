terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }

  }
}
provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}


### Store shared variables here ###
### Kubeconfig ###
variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "files/kubeconfig.yaml"
}

### S3 Credentials ###
variable "backup_s3_access" {
  description = "The Access key to access the backup S3 bucket"
  type        = string
  sensitive   = true
}

variable "backup_s3_secret" {
  description = "The Secret key to access the backup S3 bucket"
  type        = string
  sensitive   = true
}

