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