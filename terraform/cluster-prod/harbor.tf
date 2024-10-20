### Harbor ###
resource "kubernetes_secret" "s3-creds-harbor-registry" {
  metadata {
    name      = "harbor-registry-s3-creds"
    namespace = "harbor"
  }

  data = {
    "REGISTRY_STORAGE_S3_ACCESSKEY" = var.harbor_registry_s3_access
    "REGISTRY_STORAGE_S3_SECRETKEY" = var.harbor_registry_s3_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "harbor-admin-password" {
  metadata {
    name      = "harbor-admin-password"
    namespace = "harbor"
  }

  data = {
    "HARBOR_ADMIN_PASSWORD" = var.harbor_admin_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "harbor-registry-secret" {
  metadata {
    name      = "harbor-registry-secret"
    namespace = "harbor"
  }

  data = {
    "secretKey" = var.harbor_registry_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "harbor-postgres-db-credentials" {
  metadata {
    name      = "harbor-postgres-db-credentials"
    namespace = "harbor"
  }

  data = {
    "password" = var.harbor_db_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "s3-creds-harbor-db" {
  metadata {
    name      = "s3-creds"
    namespace = "harbor"
  }

  data = {
    "ACCESS_KEY_ID"     = var.backup_s3_access
    "ACCESS_SECRET_KEY" = var.backup_s3_secret
  }

  type = "Opaque"
}



### Harbor ###
variable "harbor_registry_s3_access" {
  description = "The Access key to access Harbor S3 bucket"
  type        = string
  sensitive   = true
}

variable "harbor_registry_s3_secret" {
  description = "The Secret key to access Harbor S3 bucket"
  type        = string
  sensitive   = true
}


variable "harbor_admin_password" {
  description = "The password for Harbor admin"
  type        = string
  sensitive   = true
}

variable "harbor_registry_secret" {
  description = "The secret for Harbor registry"
  type        = string
  sensitive   = true
}

variable "harbor_db_password" {
  description = "The password for Harbor database"
  type        = string
  sensitive   = true
}
