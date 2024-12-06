terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    vault = {
      source = "hashicorp/vault"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "vault" {
  token           = var.vault_token
  address         = var.vault_address
  skip_tls_verify = true # I know, I know
}
