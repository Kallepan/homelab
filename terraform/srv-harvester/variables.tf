### Kubeconfig ###
variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "files/kubeconfig.yaml"
}

### Ubuntu Password ###
variable "ubuntu_password" {
  description = "Password for the ubuntu user"
  type        = string
  sensitive   = true
}

### SSH Key ###
variable "ssh_key" {
  description = "SSH public key"
  type        = string
  default     = file("../../keys/homelab")
}

### Ubuntu Image URL ###
variable "ubuntu_image_url" {
  description = "URL to the Ubuntu 24.04 image"
  type        = string
  default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}
