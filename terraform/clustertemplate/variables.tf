// Rancher
variable "rancher_url" {
  description = "Rancher server URL"
  type        = string
  default     = "https://rancher.kite.ume.de"
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

// Rancher UI
variable "rancher_badge_color" {
  description = "Badge color for the cluster in Rancher UI"
  type        = string
  default     = "#ff0000"

  validation {
    condition     = can(regex("^(#[0-9a-fA-F]{6})$", var.rancher_badge_color))
    error_message = "Badge color must be a valid hex color code"
  }
}

variable "rancher_badge_text" {
  description = "Badge text for the cluster in Rancher UI"
  type        = string
  default     = null
}

variable "rancher_badge_icon_text" {
  description = "Badge icon text for the cluster in Rancher UI"
  type        = string
  default     = null

  validation {
    condition     = length(var.rancher_badge_icon_text) <= 3 && length(var.rancher_badge_icon_text) >= 1
    error_message = "Badge icon text must be between 0 and 3 characters"
  }
}


//  Harvester
variable "harvester_cluster_name" {
  description = "Name of the Harvester cluster imported in Rancher"
  type        = string
  default     = "kite-hci"
}

variable "harvester_vm_namespace" {
  description = "The Harvester namespace in which the guest cluster vms should be created"
  type        = string
}

// Cluster
variable "cluster_kubernetes_version" {
  description = "Kubernetes Version"
  type        = string
  default     = "v1.30.3+rke2r1"
}

variable "cluster_name" {
  description = "Name of the Cluster to create. E.g: onconnect"
  type        = string
}

variable "worker_nodes" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}
variable "worker_cpu" {
  description = "Amount of CPUs in worker nodes"
  type        = number
  default     = 16
}
variable "worker_ram" {
  description = "Amount of RAM in worker nodes"
  type        = number
  default     = 32
}

variable "worker_vm_image" {
  description = "VM image for worker nodes"
  type        = string
}

variable "worker_disk_size" {
  description = "Disk size for worker nodes"
  type        = number
  default     = 20
}

variable "control_nodes" {
  description = "Number of control nodes"
  type        = number
  default     = 1
}

variable "control_cpu" {
  description = "Amount of CPUs in control nodes"
  type        = number
  default     = 8
}

variable "control_ram" {
  description = "Amount of RAM in worker nodes"
  type        = number
  default     = 16
}

variable "control_vm_image" {
  description = "VM image for control nodes"
  type        = string
}

variable "control_disk_size" {
  description = "Disk size for control nodes"
  type        = number
  default     = 20
}

// Networks
variable "network_name" {
  description = "Network Name. E.g: partner/onconnect"
  type        = string
}

variable "nameservers" {
  description = "Nameservers for the cluster"
  type        = list(string)
  default     = null
}

variable "worker_routes" {
  description = "Routes for the worker nodes"
  type = list(object({
    to     = string
    via    = string
    metric = number
  }))
  default = []

  validation {
    condition = alltrue([
      for route in var.worker_routes :
      can(regex("^(\\d{1,3}\\.){3}\\d{1,3}/\\d{1,2}$", route.to)) &&
      can(regex("^(\\d{1,3}\\.){3}\\d{1,3}$", route.via)) &&
      route.metric >= 0
    ])
    error_message = "Each route must have a valid 'to' CIDR, 'via' IP and 'metric' value"
  }
}

/// S3 Backup - Optional ///
variable "etcd_s3_backup_bucket" {
  description = "S3 bucket to store backups"
  type        = string
  default     = null
}

variable "etcd_s3_backup_endpoint" {
  description = "S3 endpoint"
  type        = string
  default     = null
}

// Best provide these as secrets
variable "etcd_s3_access_key" {
  description = "S3 access key"
  type        = string
  sensitive   = true
  default     = null
}
variable "etcd_s3_secret_key" {
  description = "S3 secret key"
  type        = string
  sensitive   = true
  default     = null
}
