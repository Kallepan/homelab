### Rancher Credentials ###
variable "rancher_access_key" {
  description = "The access key for Rancher"
  type        = string
  sensitive   = true
}

variable "rancher_secret_key" {
  description = "The secret key for Rancher"
  type        = string
  sensitive   = true
}

### Cluster Configuration ###
variable "kubernetes_version" {
  description = "The version of Kubernetes to use"
  type        = string
  default     = "v1.30.2+rke2r1"
}
