
resource "gitlab_project_access_token" "personal_acme_zone_file_access_token" {
  project      = gitlab_project.personal_acme_zone_file.id
  name         = "ACME Access Token"
  access_level = "maintainer"
  expires_at   = "2025-09-30"
  scopes = [
    "api",
    "read_api",
  ]
}

resource "gitlab_project_variable" "cert_manager_webhook_acme_bot_secret" {
  project = gitlab_project.homelab_iac_cert_manager_webhook.id
  key     = "ACME_BOT_TOKEN"
  masked  = true
  value   = gitlab_project_access_token.personal_acme_zone_file_access_token.token
}
