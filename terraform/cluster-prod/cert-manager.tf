### Cert-Manager ###
resource "kubernetes_secret" "ca-secret" {
  metadata {
    name      = "ca-secret"
    namespace = "cert-manager"
  }

  data = {
    "tls.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
    "tls.key" = file("/workspaces/homelab/pki/output/intermediate_ca_2/private/intermediate_ca_2.key")
  }

  type = "kubernetes.io/tls"
}