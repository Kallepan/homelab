### Taints ###
resource "kubernetes_node_taint" "node1_noschedule_taint" {
  metadata {
    name = "node1"
  }

  taint {
    key    = "control-plane.kubernetes.io/NoSchedule"
    value  = "true"
    effect = "NoSchedule"
  }
}
resource "kubernetes_node_taint" "node2_noschedule_taint" {
  metadata {
    name = "node2"
  }

  taint {
    key    = "control-plane.kubernetes.io/NoSchedule"
    value  = "true"
    effect = "NoSchedule"
  }
}
resource "kubernetes_node_taint" "node3_noschedule_taint" {
  metadata {
    name = "node3"
  }

  taint {
    key    = "control-plane.kubernetes.io/NoSchedule"
    value  = "true"
    effect = "NoSchedule"
  }
}

### Labels ###

resource "kubernetes_labels" "node6-labels" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "node6"
  }

  labels = {
    "kubernetes.io/role"    = "worker"
    "kubernetes.io/storage" = "longhorn"
  }
}

resource "kubernetes_labels" "node7-labels" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "node7"
  }

  labels = {
    "kubernetes.io/role"    = "worker"
    "kubernetes.io/storage" = "longhorn"
  }
}

resource "kubernetes_labels" "node8-labels" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "node8"
  }

  labels = {
    "kubernetes.io/role"    = "worker"
    "kubernetes.io/storage" = "longhorn"
  }
}

resource "kubernetes_labels" "node9-labels" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "node9"
  }

  labels = {
    "kubernetes.io/role"    = "worker"
    "kubernetes.io/storage" = "longhorn"
  }
}

### Cert-Manager ###
resource "kubernetes_secret" "ca-secret" {
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

### Mattermost ###

resource "kubernetes_secret" "s3-creds-postgres-mattermost" {
  metadata {
    name      = "s3-creds"
    namespace = "mattermost"
  }

  data = {
    "ACCESS_KEY_ID"     = var.backup_s3_access
    "ACCESS_SECRET_KEY" = var.backup_s3_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "mattermost-database-url" {
  metadata {
    name      = "mattermost-database-secret"
    namespace = "mattermost"
  }

  data = {
    "DB_CONNECTION_STRING" = "postgres://mattermost:${var.mattermost_db_password}@mattermost-postgres-rw:5432/mattermost?sslmode=disable"
  }

  type = "Opaque"
}

### Harbor ###
resource "kubernetes_secret" "s3-creds-harbor-registry" {
  metadata {
    name      = "harbor-registry-s3-creds"
    namespace = "harbor"
  }

  data = {
    "REGISTRY_STORAGE_S3_ACCESSKEY" = var.harbor_registry_s3_access
    "REGISTRY_STORAGE_S3_SECRETKEY" = var.harbor_registry_s3_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "harbor-admin-password" {
  metadata {
    name      = "harbor-admin-password"
    namespace = "harbor"
  }

  data = {
    "HARBOR_ADMIN_PASSWORD" = var.harbor_admin_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "harbor-registry-secret" {
  metadata {
    name      = "harbor-registry-secret"
    namespace = "harbor"
  }

  data = {
    "secretKey" = var.harbor_registry_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "harbor-postgres-db-credentials" {
  metadata {
    name      = "harbor-postgres-db-credentials"
    namespace = "harbor"
  }

  data = {
    "password" = var.harbor_db_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "s3-creds-harbor-db" {
  metadata {
    name      = "s3-creds"
    namespace = "harbor"
  }

  data = {
    "ACCESS_KEY_ID"     = var.backup_s3_access
    "ACCESS_SECRET_KEY" = var.backup_s3_secret
  }

  type = "Opaque"
}

### Nextcloud ###
resource "kubernetes_secret" "s3-creds-postgres-nextcloud" {
  metadata {
    name      = "s3-creds"
    namespace = "nextcloud"
  }

  data = {
    "ACCESS_KEY_ID"     = var.backup_s3_access
    "ACCESS_SECRET_KEY" = var.backup_s3_secret
  }

  type = "Opaque"
}

### Keycloak ###
resource "kubernetes_secret" "s3-creds-postgres-keycloak" {
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

### Grafana ###

resource "kubernetes_secret" "grafana-oauth-creds" {
  metadata {
    name      = "grafana-generic-oauth-secret"
    namespace = "monitoring"
  }

  data = {
    "client_id"     = var.grafana_oauth_client_id
    "client_secret" = var.grafana_oauth_client_secret
  }

  type = "Opaque"
}

### Oauth2 Proxy ###
resource "kubernetes_secret" "oauth2-proxy-config" {
  metadata {
    name      = "oauth2-proxy-config"
    namespace = "oauth2-proxy"
  }

  data = {
    "client-id"     = var.oauth2_proxy_client_id
    "client-secret" = var.oauth2_proxy_client_secret
    "cookie-secret" = var.oauth2_proxy_cookie_secret
  }

  type = "Opaque"
}

resource "kubernetes_secret" "oauth2-proxy-ca-certs" {
  metadata {
    name      = "oauth2-proxy-ca-certs"
    namespace = "oauth2-proxy"
  }

  data = {
    "home.ca.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}
