

### GitLab-Runner ###

resource "kubernetes_secret" "gitlab-runner-token-secret" {
  metadata {
    name      = "gitlab-runner-token-secret"
    namespace = "gitlab-runner"
  }

  data = {
    "runner-registration-token" = ""
    "runner-token"              = var.gitlab_runner_token
  }

  type = "Opaque"
}

resource "kubernetes_secret" "gitlab-runner-ca" {
  metadata {
    name      = "gitlab-ca"
    namespace = "gitlab-runner"
  }

  data = {
    "gitlab.srv-lab.server.home.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}

### GitLab ###

resource "kubernetes_secret" "s3-creds-postgres-gitlab" {
  metadata {
    name      = "s3-creds"
    namespace = "gitlab"
  }

  data = {
    "ACCESS_KEY_ID"     = var.backup_s3_access
    "ACCESS_SECRET_KEY" = var.backup_s3_secret
  }

  type = "Opaque"
}


resource "kubernetes_secret" "gitlab-oidc-creds" {
  metadata {
    name      = "gitlab-keycloak-omniauth"
    namespace = "gitlab"
  }

  data = {
    "omniauth.yml" = file("files/gitlab-openid-secret.yaml")
  }
  type = "Opaque"
}

resource "kubernetes_secret" "gitlab-minio-creds" {
  metadata {
    name      = "gitlab-minio-creds"
    namespace = "gitlab"
  }

  data = {
    "s3cmd" = file("files/gitlab-s3cmd")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "gitlab-registry-minio-connection" {
  metadata {
    name      = "gitlab-registry-minio-connection"
    namespace = "gitlab"
  }

  data = {
    "registry.s3.yml" = file("files/gitlab-registry.s3.yml")
  }
}

resource "kubernetes_secret" "gitlab-minio-connection" {
  metadata {
    name      = "gitlab-minio-connection"
    namespace = "gitlab"
  }

  data = {
    "connection.yml" = file("files/gitlab-minio-connection.yml")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "gitlab-ca" {
  metadata {
    name      = "gitlab-ca"
    namespace = "gitlab"
  }

  data = {
    "gitlab.srv-lab.server.home.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}

### Gitlab ###
variable "gitlab_runner_token" {
  description = "The token for Gitlab runner"
  type        = string
  sensitive   = true
}

