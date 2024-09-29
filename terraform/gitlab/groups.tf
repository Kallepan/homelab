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

resource "gitlab_group" "personal" {
  path = "personal"
  name = "Personal"
}
