### Store shared variables here ###
### Kubeconfig ###
variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "/workspaces/homelab/clusters/core/configs/kubeconfig"
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

### GitLab Runner ###
variable "gitlab_runner_token" {
  description = "The token for Gitlab runner"
  type        = string
  sensitive   = true
}

variable "gitlab_runner_s3_access" {
  description = "The Access key to access the GitLab runner S3 bucket"
  type        = string
  sensitive   = true
}

variable "gitlab_runner_s3_secret" {
  description = "The Secret key to access the GitLab runner S3 bucket"
  type        = string
  sensitive   = true
}


### Grafana ###
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

### Alertmanager ###
variable "alertmanager_mattermost_webhook_url" {
  description = "Mattermost webhook URL for Alertmanager"
  sensitive   = true
}
