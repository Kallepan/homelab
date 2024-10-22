// IAC READ API Access Token
resource "gitlab_group_access_token" "iac_access_token" {
  group        = gitlab_group.homelab_iac.id
  name         = "IAC Access Token"
  access_level = "maintainer"
  expires_at   = "2025-09-30"
  scopes = [
    "read_api"
  ]
}

resource "gitlab_group_variable" "clusters_iac_access_token" {
  group             = gitlab_group.clusters.id
  key               = "IAC_ACCESS_TOKEN"
  value             = gitlab_group_access_token.iac_access_token.token
  masked            = true
  environment_scope = "*"
}

resource "gitlab_group_variable" "clusters_rancher_access_key" {
  group             = gitlab_group.clusters.id
  key               = "TF_VAR_rancher_access_key"
  value             = var.rancher2_access_key
  masked            = true
  environment_scope = "*"
}

resource "gitlab_group_variable" "clusters_rancher_secret_key" {
  group             = gitlab_group.clusters.id
  key               = "TF_VAR_rancher_secret_key"
  value             = var.rancher2_secret_key
  masked            = true
  environment_scope = "*"
}

// IAC Operators READ Registry Access Token
resource "gitlab_group_access_token" "iac_operators_access_token" {
  group        = gitlab_group.homelab_iac_operators.id
  name         = "IAC Operators Access Token"
  access_level = "maintainer"
  expires_at   = "2025-09-30"
  scopes = [
    "read_registry",
    "read_repository"
  ]
}

resource "gitlab_group_variable" "iac_operators_access_token" {
  group             = gitlab_group.homelab_iac_operators.id
  key               = "IAC_OPERATORS_READ_REGISTRY_ACCESS_TOKEN"
  value             = gitlab_group_access_token.iac_operators_access_token.token
  masked            = true
  environment_scope = "*"
}
