output "instance" {
  description = "A reference (self_link) to the bastion host's VM instance"
  value       = google_compute_instance.bastion_host.self_link
}

output "address" {
  description = "The public IP of the bastion host."
  value       = google_compute_instance.bastion_host.network_interface[0].access_config[0].nat_ip
  # wait on access_config list to be populated. this seems to be a TF bug.
  depends_on = [
    google_compute_instance.bastion_host.network_interface[0].access_config
  ]
}

output "private_ip" {
  description = "The private IP of the bastion host."
  value       = google_compute_instance.bastion_host.network_interface[0].network_ip
}
