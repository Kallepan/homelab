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
    "ca.crt"                            = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}

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

resource "kubernetes_secret" "gitlab_s3_access" {
  metadata {
    name      = "gitlab-runner-s3-access"
    namespace = "gitlab-runner"
  }

  data = {
    "accesskey" = var.gitlab_runner_s3_access
    "secretkey" = var.gitlab_runner_s3_secret
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

### Alertmanager ###
resource "kubernetes_secret" "alertmanager_mattermost_webhook_url" {
  metadata {
    name      = "alertmanager-mattermost-webhook-url"
    namespace = "monitoring"
  }

  data = {
    "mattermost_api_url" = var.alertmanager_mattermost_webhook_url
  }

  type = "Opaque"
}
resource "kubernetes_secret" "alertmanager_ca" {
  metadata {
    name      = "alertmanager-ca"
    namespace = "monitoring"
  }

  data = {
    "ca.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}

### Prometheus ###
resource "kubernetes_secret" "vault_metrics_client" {
  metadata {
    name      = "vault-metrics-client"
    namespace = "vault"
  }

  data = {
    "token" = vault_token.prometheus_token.client_token
  }

  type = "Opaque"
}

### Vault ###
## Metrics ##
resource "vault_policy" "prometheus_metrics" {
  name   = "prometheus-metrics"
  policy = <<EOF
# Policy name: prometheus-metrics
#
# Read only permissions on 'sys/metrics' path
path "sys/metrics" {
  capabilities = ["read"]
}
EOF
}

resource "vault_token" "prometheus_token" {
  policies = [vault_policy.prometheus_metrics.name]
}

## Gitlab Integration ##
resource "vault_jwt_auth_backend" "gitlab_oidc" {
  path                  = "jwt_v2"
  oidc_discovery_url    = var.vault_gitlab_oidc_discovery_url
  bound_issuer          = var.vault_gitlab_oidc_issuer
  oidc_discovery_ca_pem = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")

  description = "GitLab OIDC Integration"
}

# Key Value Secrets
resource "vault_mount" "kv_secret" {
  path        = "secret"
  type        = "kv"
  description = "Secrets for the homelab"
  options = {
    version = "2"
  }
}

# Secrets
resource "vault_kv_secret_v2" "secret_showcase_prod" {
  mount = vault_mount.kv_secret.path
  name  = "showcase/prod/db"

  data_json = jsonencode({
    password = var.vault_test_secret
  })
}

resource "vault_kv_secret_v2" "secret_showcase_staging" {
  mount = vault_mount.kv_secret.path
  name  = "showcase/staging/db"

  data_json = jsonencode({
    password = var.vault_test_secret
  })
}

# Policies
resource "vault_policy" "showcase_prod" {
  name   = "showcase-prod"
  policy = <<EOF
# Policy name: showcase-prod
#
# Read only permissions on 'showcase/prod/*' path
path "secret/data/showcase/prod/*" {
  capabilities = ["read"]
}
EOF
}

resource "vault_policy" "showcase_staging" {
  name   = "showcase-staging"
  policy = <<EOF
# Policy name: showcase-staging
#
# Read only permissions on 'showcase/staging/*' path
path "secret/data/showcase/staging/*" {
  capabilities = ["read"]
}
EOF
}

# Authentication Policies
resource "vault_jwt_auth_backend_role" "showcase_prod" {
  backend   = vault_jwt_auth_backend.gitlab_oidc.path
  role_name = "showcase-prod"

  token_policies         = [vault_policy.showcase_prod.name]
  token_explicit_max_ttl = 600

  bound_claims_type = "glob"
  bound_claims = {
    "project_id"    = "17"
    "ref"           = "auto-deploy-*"
    "ref_type"      = "branch"
    "ref_protected" = "true"
  }
  bound_audiences = ["https://vault.core.infra.server.home"]

  user_claim = "user_email"
  role_type  = "jwt"
}
resource "vault_jwt_auth_backend_role" "showcase_staging" {
  backend   = vault_jwt_auth_backend.gitlab_oidc.path
  role_name = "showcase-staging"

  token_policies         = [vault_policy.showcase_staging.name]
  token_explicit_max_ttl = 600

  bound_claims = {
    "project_id" = "17"
    "ref"        = "main"
    "ref_type"   = "branch"
  }
  bound_audiences = ["https://vault.core.infra.server.home"]

  user_claim = "user_email"
  role_type  = "jwt"
}

### Flux ###
### Flux System ###
resource "kubernetes_secret" "flux-ca" {
  metadata {
    name      = "flux-ca"
    namespace = "flux-system"
  }

  data = {
    "ca.crt" = file("/workspaces/homelab/pki/output/intermediate_ca_2/intermediate_ca_2_chain.crt")
  }

  type = "Opaque"
}

resource "kubernetes_secret" "mattermost-webhook-url" {
  metadata {
    name      = "mattermost-webhook-url"
    namespace = "flux-system"
  }

  data = {
    "address" = var.flux_system_mattermost_webhook_url
  }

  type = "Opaque"
}
