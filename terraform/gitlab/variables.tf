variable "gitlab_token" {
  description = "Gitlab token"
  sensitive   = true
}

variable "rancher2_access_key" {
  description = "Rancher access key"
  type        = string
  sensitive   = true
}

variable "rancher2_secret_key" {
  description = "Rancher secret key"
  type        = string
  sensitive   = true
}
