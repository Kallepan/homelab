terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }

  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}
