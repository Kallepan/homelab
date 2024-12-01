### Cert-Manager ###
resource "kubernetes_secret" "ca_secret" {
  metadata {
    name      = "ca-secret"
    namespace = "cert-manager"
  }

  data = {
    "tls.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
    "tls.key" = file("/workspaces/homelab/pki/output/intermediate_ca_2/private/intermediate_ca_2.key")
  }

  type = "kubernetes.io/tls"
}

### Keycloak ###
resource "kubernetes_secret" "s3_creds_postgres_keycloak" {
  metadata {
    name      = "s3-creds"
    namespace = "keycloak"
  }

  data = {
    "ACCESS_KEY_ID"     = var.backup_s3_access
    "ACCESS_SECRET_KEY" = var.backup_s3_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "s3_endpoint_ca_postgres_keycloak" {
  metadata {
    name      = "s3-ca"
    namespace = "keycloak"
  }

  data = {
    "ca.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}

### GitLab ###
### GitLab-Runner ###
resource "kubernetes_secret" "gitlab_runner_token_secret" {
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

resource "kubernetes_secret" "gitlab_runner_ca" {
  metadata {
    name      = "gitlab-ca"
    namespace = "gitlab-runner"
  }

  data = {
    "gitlab.core.infra.server.home.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "s3_creds_postgres_gitlab" {
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

resource "kubernetes_secret" "s3_endpoint_ca_postgres_gitlab" {
  metadata {
    name      = "s3-ca"
    namespace = "gitlab"
  }

  data = {
    "ca.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}


resource "kubernetes_secret" "gitlab_oidc_creds" {
  metadata {
    name      = "gitlab-keycloak-omniauth"
    namespace = "gitlab"
  }

  data = {
    "omniauth.yml" = file("${path.module}/files/gitlab-openid-secret.yaml")
  }
  type = "Opaque"
}

resource "kubernetes_secret" "gitlab_backups_minio_creds" {
  metadata {
    name      = "gitlab-backups-minio-creds"
    namespace = "gitlab"
  }

  data = {
    "config" = file("${path.module}/files/gitlab-backup.s3cfg")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "gitlab_registry_minio_connection" {
  metadata {
    name      = "gitlab-registry-minio-connection"
    namespace = "gitlab"
  }

  data = {
    "registry.s3.yml" = file("${path.module}/files/gitlab-registry.s3.yml")
  }
}

resource "kubernetes_secret" "gitlab_minio_connection" {
  metadata {
    name      = "gitlab-minio-connection"
    namespace = "gitlab"
  }

  data = {
    "connection.yml" = file("${path.module}/${path.module}/files/gitlab-minio-connection.yml")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "gitlab_ca" {
  metadata {
    name      = "gitlab-ca"
    namespace = "gitlab"
  }

  data = {
    "gitlab.core.infra.server.home.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}

