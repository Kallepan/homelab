### MINIO ###
resource "kubernetes_secret" "minio-storage-user" {
  metadata {
    name      = "storage-user"
    namespace = "minio-tenant"
  }

  data = {
    "CONSOLE_ACCESS_KEY" = var.minio_console_access_key
    "CONSOLE_SECRET_KEY" = var.minio_console_secret_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "minio-storage-configuration" {
  metadata {
    name      = "storage-configuration"
    namespace = "minio-tenant"
  }

  data = {
    "config.env" = <<-EOF
      export MINIO_ROOT_USER="${var.minio_root_user}"
      export MINIO_ROOT_PASSWORD="${var.minio_root_password}"
      export MINIO_STORAGE_CLASS_STANDARD="EC:2"
      export MINIO_BROWSER="on"
    EOF
  }

  type = "Opaque"
}

### MINIO ###
variable "minio_root_user" {
  description = "The root user for Minio"
  type        = string
  sensitive   = true
}

variable "minio_root_password" {
  description = "The root password for Minio"
  type        = string
  sensitive   = true
}

variable "minio_console_access_key" {
  description = "The access key for Minio console"
  type        = string
  sensitive   = true
}

variable "minio_console_secret_key" {
  description = "The secret key for Minio console"
  type        = string
  sensitive   = true
}
