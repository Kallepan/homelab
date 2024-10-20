### Nextcloud ###
resource "kubernetes_secret" "s3-creds-postgres-nextcloud" {
  metadata {
    name      = "s3-creds"
    namespace = "nextcloud"
  }

  data = {
    "ACCESS_KEY_ID"     = var.backup_s3_access
    "ACCESS_SECRET_KEY" = var.backup_s3_secret
  }

  type = "Opaque"
}