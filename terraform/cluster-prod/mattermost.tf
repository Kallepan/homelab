### Mattermost ###
resource "kubernetes_secret" "s3-creds-postgres-mattermost" {
  metadata {
    name      = "s3-creds"
    namespace = "mattermost"
  }

  data = {
    "ACCESS_KEY_ID"     = var.backup_s3_access
    "ACCESS_SECRET_KEY" = var.backup_s3_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "mattermost-database-url" {
  metadata {
    name      = "mattermost-database-secret"
    namespace = "mattermost"
  }

  data = {
    "DB_CONNECTION_STRING" = "postgres://mattermost:${var.mattermost_db_password}@mattermost-postgres-rw:5432/mattermost?sslmode=disable"
  }

  type = "Opaque"
}