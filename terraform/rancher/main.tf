resource "rancher2_cluster" "core_cluster" {
  name        = "core"
  description = "Core cluster"
  annotations = {
    "ui.rancher/badge-color" = "#001e57"
    "ui.rancher/badge-text"  = "CRE"
  }
}

resource "rancher2_cluster" "production_cluster" {
  name        = "production"
  description = "Production cluster"
  annotations = {
    "ui.rancher/badge-color" = "#001e57"
    "ui.rancher/badge-text"  = "PRO"
  }
}

resource "rancher2_cluster" "staging_cluster" {
  name        = "staging"
  description = "Staging cluster"
  annotations = {
    "ui.rancher/badge-color" = "#001e57"
    "ui.rancher/badge-text"  = "STG"
  }
}
