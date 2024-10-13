
resource "gitlab_project" "homelab_iac_clustertemplate" {
  path             = "clustertemplate"
  name             = "Clustertemplate"
  description      = "Terraform Cluster Creation Template"
  visibility_level = "private"
  namespace_id     = gitlab_group.homelab_iac.id
}

resource "gitlab_project" "homelab_deployments_test_cluster" {
  path             = "test-cluster"
  name             = "Test Cluster"
  description      = "Test Cluster Deployment"
  visibility_level = "private"
  namespace_id     = gitlab_group.homelab_deployments.id
}
