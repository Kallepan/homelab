### Keycloak ###
resource "kubernetes_secret" "s3-creds-postgres-keycloak" {
  metadata {
    name      = "s3-creds"
    namespace = "keycloak"
  }

  data = {
    "ACCESS_KEY_ID"     = var.backup_s3_access
    "ACCESS_SECRET_KEY" = var.backup_s3_secret
  }

  type = "Opaque"
}