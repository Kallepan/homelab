resource "gitlab_group" "homelab" {
  path = "homelab"
  name = "Homelab"
}

resource "gitlab_group" "homelab_deployments" {
  path      = "deployments"
  name      = "Deployments"
  parent_id = gitlab_group.homelab.id
}

resource "gitlab_group" "homelab_iac" {
  path      = "iac"
  name      = "IAC"
  parent_id = gitlab_group.homelab.id
}

resource "gitlab_project" "homelab_iac_clustertemplate" {
  path             = "clustertemplate"
  name             = "Clustertemplate"
  description      = "Terraform Cluster Creation Template"
  visibility_level = "private"
  namespace_id     = gitlab_group.homelab_iac.id
}
