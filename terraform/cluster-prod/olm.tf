resource "kubernetes_secret" "olm-image-pull-secret" {
  metadata {
    name      = "olm-image-pull-secret"
    namespace = "olm"
  }

  type = "kubernetes.io/dockerconfigjson"


  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.gitlab_registry_server}" = {
          "username" = var.olm_gitlab_registry_username
          "password" = var.olm_gitlab_registry_password
          "auth"     = base64encode("${var.olm_gitlab_registry_username}:${var.olm_gitlab_registry_password}")
        }
      }
    })
  }
}

variable "olm_gitlab_registry_username" {
  description = "The username for the OLM user of the Gitlab Registry"
  type        = string
  sensitive   = true
}

variable "olm_gitlab_registry_password" {
  description = "The password for the OLM user of the Gitlab Registry"
  type        = string
  sensitive   = true
}
