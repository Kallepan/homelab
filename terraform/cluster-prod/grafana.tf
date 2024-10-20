
### Grafana ###
resource "kubernetes_secret" "grafana-oauth-creds" {
  metadata {
    name      = "grafana-generic-oauth-secret"
    namespace = "monitoring"
  }

  data = {
    "client_id"     = var.grafana_oauth_client_id
    "client_secret" = var.grafana_oauth_client_secret
  }

  type = "Opaque"
}
### Oauth Credentials ###
variable "grafana_oauth_client_id" {
  description = "The client ID for Grafana OAuth"
  type        = string
  sensitive   = true
}

variable "grafana_oauth_client_secret" {
  description = "The client secret for Grafana OAuth"
  type        = string
  sensitive   = true
}

