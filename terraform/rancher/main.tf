

resource "rancher2_cluster_v2" "cluster_staging" {
  name               = "staging"
  kubernetes_version = var.kubernetes_version

  annotations = {
    "ui.rancher/badge-color"      = "#00ff00"
    "ui.rancher/badge-icon-text"  = "STG"
    "field.cattle.io/description" = "Terraform managed cluster"
  }
}

resource "rancher2_cluster_v2" "cluster_wasm" {
  name               = "wasm"
  kubernetes_version = var.kubernetes_version

  annotations = {
    "ui.rancher/badge-color"      = "#0000ff"
    "ui.rancher/badge-icon-text"  = "WSM"
    "field.cattle.io/description" = "Terraform managed cluster"
  }
}
