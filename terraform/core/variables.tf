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

### Vault ###
variable "vault_token" {
  description = "The token for Vault"
  type        = string
  sensitive   = true
}

variable "vault_address" {
  description = "The address for Vault"
  type        = string
  default     = "https://vault.core.infra.server.home"
}

variable "vault_gitlab_oidc_discovery_url" {
  description = "The GitLab OIDC discovery URL for Vault"
  type        = string
  default     = "https://gitlab.core.infra.server.home"
}

variable "vault_gitlab_oidc_issuer" {
  description = "The GitLab OIDC client ID for Vault"
  type        = string
  default     = "https://gitlab.core.infra.server.home"
}

## Test Secrets ##
variable "vault_test_secret" {
  description = "A test secret"
  type        = string
  sensitive   = true
}

### Flux ###
variable "flux_system_mattermost_webhook_url" {
  description = "Mattermost webhook URL for Flux"
  sensitive   = true
}