resource "gitlab_group" "homelab" {
  path = "homelab"
  name = "Homelab"
}

resource "gitlab_group" "homelab_deployments" {
  path      = "deployments"
  name      = "Deployments"
  parent_id = gitlab_group.homelab.id
}

resource "gitlab_group" "clusters" {
  path      = "clusters"
  name      = "Clusters"
  parent_id = gitlab_group.homelab_deployments.id
}

resource "gitlab_group" "homelab_iac" {
  path      = "iac"
  name      = "IAC"
  parent_id = gitlab_group.homelab.id
}

resource "gitlab_group" "homelab_iac_operators" {
  path      = "operators"
  name      = "Operators"
  parent_id = gitlab_group.homelab_iac.id
}

resource "gitlab_group" "personal" {
  path = "personal"
  name = "Personal"
}
