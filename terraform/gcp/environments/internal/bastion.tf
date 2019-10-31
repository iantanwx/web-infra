module "jump_box" {
  source                = "../../modules/network/modules/bastion-host"
  project               = google_project.project.project_id
  instance_name         = "${var.host_project_name}-jump-box"
  subnetwork            = module.internal_vpc.public_subnetwork
  zone                  = "asia-southeast1-a"
  tag                   = "public-restricted"
  static_ip             = google_compute_address.jump_box_ip.address
  startup_script        = file("${path.module}/../common/files/bastion-startup.sh")
  service_account_email = google_service_account.k8s_admin.email
  service_account_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
}

resource "google_compute_address" "jump_box_ip" {
  name         = "${var.host_project_name}-jump-box-ip"
  project      = google_project.project.project_id
  address_type = "EXTERNAL"
}
