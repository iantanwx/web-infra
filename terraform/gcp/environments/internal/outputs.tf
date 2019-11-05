# project outputs
output "project" {
  value = google_project.project.project_id
}

# network outputs
output "network" {
  value = module.internal_vpc.network
}

# bastion host ip
output "jump_box_ip" {
  value = google_compute_address.jump_box_ip.address
}

output "runner_ips" {
  value = module.gitlab_runner.privileged_runner_ip
}
