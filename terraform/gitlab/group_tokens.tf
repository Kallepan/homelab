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
