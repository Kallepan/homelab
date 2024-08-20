resource "rancher2_cluster_v2" "cluster-staging" {
  name               = "staging"
  kubernetes_version = var.kubernetes_version
}
