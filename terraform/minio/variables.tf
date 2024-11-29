variable "minio_user" {
  description = "The user for Minio"
  type        = string
  sensitive   = true
}

variable "minio_password" {
  description = "The password for Minio"
  type        = string
  sensitive   = true
}
