output "registration_token" {
  value = nonsensitive(rancher2_cluster_v2.cluster_staging.cluster_registration_token)
}
