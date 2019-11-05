output "privileged_sa" {
  value       = google_service_account.runner_privileged_sa.email
  description = <<EOF
The service account created for the worker instances.
Privileges/roles may need to be assigned to this service account depending on the activities
performed by the build.
EOF
}

output "unprivileged_sa" {
  value = google_service_account.runner_unprivileged_sa.email
}

output "privileged_runner_ip" {
  value = [google_compute_instance.runner_privileged.*.network_interface]
  description = "IP addresses of privileged runners"
}
