# project outputs
output "project" {
  value = google_project.project.project_id
}

# network outputs
output "network" {
  value = module.stg_app_vpc.network
}

# bastion host ip
output "jump_box_ip" {
  value = google_compute_address.jump_box_ip.address
}

# k8s outputs
output "k8s_admin_sa" {
  value = google_service_account.k8s_admin.account_id
}

output "k8s_cluster_sa" {
  description = "The service account attached to GKE cluster nodes"
  value       = module.gke_service_account.email
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master."
  sensitive   = true
  value       = module.gke_cluster.endpoint
}

output "client_key" {
  description = "Private key used by clients to authenticate to the cluster endpoint."
  sensitive   = true
  value       = module.gke_cluster.client_key
}

output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster."
  sensitive   = true
  value       = module.gke_cluster.cluster_ca_certificate
}
