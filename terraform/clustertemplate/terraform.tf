terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "3.4.2"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "4.1.0"
    }
  }
}
