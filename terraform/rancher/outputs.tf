output "registration_token" {
  value = nonsensitive(rancher2_cluster_v2.cluster-staging.cluster_registration_token)
}
