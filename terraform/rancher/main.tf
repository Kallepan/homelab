resource "rancher2_cluster" "core_cluster" {
  name        = "core"
  description = "Core cluster"
  annotations = {
    "ui.rancher/badge-color" = "#001e57"
    "ui.rancher/badge-text"  = "CRE"
    "ui.rancher/badge-text"  = "CRE"
  }
}
