terraform {
  required_providers {
    minio = {
      source = "aminueza/minio"
    }
  }
}

provider "minio" {
  minio_server   = "api.minio.srv-lab.server.home"
  minio_region   = "eu-west-1"
  minio_user     = var.minio_user
  minio_password = var.minio_password
  minio_ssl      = false
}
