module "stg_app_vpc" {
  source      = "../../modules/network/modules/vpc-network"
  project     = google_project.project.project_id
  name_prefix = var.host_project_name
  region      = var.region

  cidr_block                            = var.vpc_cidr_primary
  secondary_cidr_block                  = var.vpc_cidr_secondary
  allowed_public_restricted_subnetworks = var.public_restricted_whitelist
}

resource "google_compute_network_peering" "stg-to-internal" {
  name         = "internal-to-stg"
  network      = module.stg_app_vpc.network
  peer_network = var.internal_network
}
