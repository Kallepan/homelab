### Store shared variables here ###
### Kubeconfig ###
variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "/workspaces/homelab/clusters/core/_out/kubeconfig"
}

### S3 Credentials ###
variable "backup_s3_access" {
  description = "The Access key to access the backup S3 bucket"
  type        = string
  sensitive   = true
}

variable "backup_s3_secret" {
  description = "The Secret key to access the backup S3 bucket"
  type        = string
  sensitive   = true
}
