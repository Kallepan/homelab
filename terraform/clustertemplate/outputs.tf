output "cluster_name" {
  description = "Name of the created Cluster"
  value       = rancher2_cluster_v2.rke2_cluster.id
}

output "cluster_id" {
  description = "ID of the created Cluster"
  value       = rancher2_cluster_v2.rke2_cluster.cluster_v1_id
}
