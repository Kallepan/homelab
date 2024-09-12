### Kubeconfig ###
variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "files/kubeconfig.yaml"
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

variable "gitlab_s3_access" {
  description = "The Access key to access Gitlab S3 bucket"
  type        = string
  sensitive   = true
}

variable "gitlab_s3_secret" {
  description = "The Secret key to access Gitlab S3 bucket"
  type        = string
  sensitive   = true
}

variable "mattermost_s3_access" {
  description = "The Access key to access Mattermost S3 bucket"
  type        = string
  sensitive   = true
}

variable "mattermost_s3_secret" {
  description = "The Secret key to access Mattermost S3 bucket"
  type        = string
  sensitive   = true
}

### Oauth Credentials ###

variable "grafana_oauth_client_id" {
  description = "The client ID for Grafana OAuth"
  type        = string
  sensitive   = true
}

variable "grafana_oauth_client_secret" {
  description = "The client secret for Grafana OAuth"
  type        = string
  sensitive   = true
}

### Gitlab ###
variable "gitlab_runner_token" {
  description = "The token for Gitlab runner"
  type        = string
  sensitive   = true
}

### Mattermost ###

variable "mattermost_db_password" {
  description = "The password for Mattermost database"
  type        = string
  sensitive   = true
}
