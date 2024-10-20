### Dashboard
resource "kubernetes_secret" "wazuh-dashboard-creds" {
  metadata {
    name      = "dashboard-cred"
    namespace = "wazuh"
  }

  type = "Opaque"

  data = {
    "username" = var.wazuh_dashboard_username
    "password" = var.wazuh_dashboard_password
  }
}

variable "wazuh_dashboard_username" {
  description = "The username for the Wazuh dashboard"
  type        = string
}

variable "wazuh_dashboard_password" {
  description = "The password for the Wazuh dashboard"
  type        = string
  sensitive   = true
}

### Indexer
resource "kubernetes_secret" "wazuh-indexer-creds" {
  metadata {
    name      = "indexer-cred"
    namespace = "wazuh"
  }

  type = "Opaque"

  data = {
    "username" = var.wazuh_indexer_username
    "password" = var.wazuh_indexer_password
  }
}

variable "wazuh_indexer_username" {
  description = "The username for the Wazuh indexer"
  type        = string
}

variable "wazuh_indexer_password" {
  description = "The password for the Wazuh indexer"
  type        = string
  sensitive   = true
}

### API
resource "kubernetes_secret" "wazuh-api-creds" {
  metadata {
    name      = "api-cred"
    namespace = "wazuh"
  }

  type = "Opaque"

  data = {
    "username" = var.wazuh_api_username
    "password" = var.wazuh_api_password
  }
}

variable "wazuh_api_username" {
  description = "The username for the Wazuh API"
  type        = string
}

variable "wazuh_api_password" {
  description = "The password for the Wazuh API"
  type        = string
  sensitive   = true
}

### AuthD
resource "kubernetes_secret" "wazuh-authd-creds" {
  metadata {
    name      = "wazuh-authd-pass"
    namespace = "wazuh"
  }
  type = "Opaque"

  data = {
    "authd.pass" = var.wazuh_authd_password
  }
}

variable "wazuh_authd_password" {
  description = "The password for the Wazuh authd"
  type        = string
  sensitive   = true
}

### Cluster Key Secret
resource "kubernetes_secret" "wazuh-cluster-key" {
  metadata {
    name      = "wazuh-cluster-key"
    namespace = "wazuh"
  }

  type = "Opaque"

  data = {
    "key" = var.wazuh_cluster_key
  }
}

variable "wazuh_cluster_key" {
  description = "The cluster key for Wazuh"
  type        = string
  sensitive   = true
}


resource "kubernetes_secret" "wazuh-indexer_certs" {
  metadata {
    name      = "indexer-certs"
    namespace = "wazuh"
  }

  data = {
    "root-ca.pem"       = filebase64("${path.module}/files/wazuh/indexer_cluster/root-ca.pem")
    "node.pem"          = filebase64("${path.module}/files/wazuh/indexer_cluster/node.pem")
    "node-key.pem"      = filebase64("${path.module}/files/wazuh/indexer_cluster/node-key.pem")
    "dashboard.pem"     = filebase64("${path.module}/files/wazuh/indexer_cluster/dashboard.pem")
    "dashboard-key.pem" = filebase64("${path.module}/files/wazuh/indexer_cluster/dashboard-key.pem")
    "admin.pem"         = filebase64("${path.module}/files/wazuh/indexer_cluster/admin.pem")
    "admin-key.pem"     = filebase64("${path.module}/files/wazuh/indexer_cluster/admin-key.pem")
    "filebeat.pem"      = filebase64("${path.module}/files/wazuh/indexer_cluster/filebeat.pem")
    "filebeat-key.pem"  = filebase64("${path.module}/files/wazuh/indexer_cluster/filebeat-key.pem")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "wazuh-dashboard_certs" {
  metadata {
    name      = "dashboard-certs"
    namespace = "wazuh"
  }

  data = {
    "cert.pem"    = filebase64("${path.module}/files/wazuh/dashboard_http/cert.pem")
    "key.pem"     = filebase64("${path.module}/files/wazuh/dashboard_http/key.pem")
    "root-ca.pem" = filebase64("${path.module}/files/wazuh/indexer_cluster/root-ca.pem")
  }

  type = "Opaque"
}

resource "kubernetes_config_map" "wazuh-indexer-conf" {
  metadata {
    name      = "indexer-conf"
    namespace = "wazuh"
  }

  data = {
    "opensearch.yml"     = file("${path.module}/files/wazuh/opensearch.yml")
    "internal_users.yml" = file("${path.module}/files/wazuh/internal_users.yml")
  }
}
