module "jump_box" {
  source = "../../modules/network/modules/bastion-host"
  project = google_project.project.project_id
  instance_name = "${var.host_project_name}-jump-box"
  subnetwork = module.stg_app_vpc.public_subnetwork
  zone = "asia-southeast1-a"
  tag = "public-restricted"
}

resource "google_compute_address" "jump_box_ip" {
  name = "${var.host_project_name}-jump-box-ip"
  project = google_project.project.project_id
  address_type = "EXTERNAL"
}

output "jump_box_ip" {
  value = google_compute_address.jump_box_ip.address
}
