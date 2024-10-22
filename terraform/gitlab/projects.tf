
resource "gitlab_project" "homelab_iac_clustertemplate" {
  path             = "clustertemplate"
  name             = "Clustertemplate"
  description      = "Terraform Cluster Creation Template"
  visibility_level = "private"
  namespace_id     = gitlab_group.homelab_iac.id
}

resource "gitlab_project" "homelab_iac_cert_manager_webhook" {
  path             = "cert-manager-webhook"
  name             = "Cert Manager Webhook"
  description      = "Cert Manager Webhook Deployment"
  visibility_level = "private"
  namespace_id     = gitlab_group.homelab_iac.id
}

resource "gitlab_project" "homelab_deployments_test_cluster" {
  path             = "test-cluster"
  name             = "Test Cluster"
  description      = "Test Cluster Deployment"
  visibility_level = "private"
  namespace_id     = gitlab_group.clusters.id
}

resource "gitlab_project" "personal_acme_zone_file" {
  path             = "acme-zone-file"
  name             = "ACME Zone File"
  description      = "ACME DNS Zone File"
  visibility_level = "private"
  namespace_id     = gitlab_group.personal.id
}

### Operators
resource "gitlab_project" "operators_homelab_catalog" {
  path             = "catalog"
  name             = "Catalog"
  description      = "Operators Catalog"
  visibility_level = "private"
  namespace_id     = gitlab_group.homelab_iac_operators.id
}

resource "gitlab_project" "operators_rq_operator" {
  path             = "rq-operator"
  name             = "ResourceQuota Operator"
  description      = "ResourceQuota Operator"
  visibility_level = "private"
  namespace_id     = gitlab_group.homelab_iac_operators.id
}
