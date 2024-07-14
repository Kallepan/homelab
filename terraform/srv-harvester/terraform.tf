terraform {
  required_version = ">= 0.13"
  required_providers {
    harvester = {
      source = "harvester/harvester"
    }
  }
}

provider "harvester" {
  kubeconfig = file(var.kubeconfig_path)
}
