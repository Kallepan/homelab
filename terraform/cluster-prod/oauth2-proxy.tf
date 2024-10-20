### Oauth2 Proxy ###
resource "kubernetes_secret" "oauth2-proxy-config" {
  metadata {
    name      = "oauth2-proxy-config"
    namespace = "oauth2-proxy"
  }

  data = {
    "client-id"     = var.oauth2_proxy_client_id
    "client-secret" = var.oauth2_proxy_client_secret
    "cookie-secret" = var.oauth2_proxy_cookie_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "oauth2-proxy-ca-certs" {
  metadata {
    name      = "oauth2-proxy-ca-certs"
    namespace = "oauth2-proxy"
  }

  data = {
    "home.ca.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}

### Oauth2 Proxy ###
variable "oauth2_proxy_client_id" {
  description = "The client ID for Oauth2 Proxy"
  type        = string
  sensitive   = true
}

variable "oauth2_proxy_client_secret" {
  description = "The client secret for Oauth2 Proxy"
  type        = string
  sensitive   = true
}

variable "oauth2_proxy_cookie_secret" {
  description = "The cookie secret for Oauth2 Proxy"
  type        = string
  sensitive   = true
}
