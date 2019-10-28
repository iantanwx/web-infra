# GKE control plane module
module "gke_cluster" {
  source = "../../modules/gke/modules/gke-cluster"

  project  = google_project.project.project_id
  location = var.region
  name     = var.cluster_name

  network                      = module.stg_app_vpc.network
  subnetwork                   = module.stg_app_vpc.public_subnetwork
  cluster_secondary_range_name = module.stg_app_vpc.public_subnetwork_secondary_range_name

  enable_private_nodes   = true
  master_ipv4_cidr_block = var.master_cidr_block
  # TODO: this should be turned off. used for testing only.
  disable_public_endpoint = false
  # TODO: restrict to bastion host
  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = "0.0.0.0/0"
          display_name = "fix me"
        }
      ]
    }
  ]
}

# GKE node pool module
resource "google_container_node_pool" "node_pool" {
  provider = google-beta

  name     = "main-pool"
  project  = google_project.project.project_id
  location = var.region
  cluster  = module.gke_cluster.name

  initial_node_count = var.k8s_initial_node_count

  autoscaling {
    min_node_count = var.k8s_min_node_count
    max_node_count = var.k8s_max_node_count
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    image_type   = "COS"
    machine_type = "n1-standard-1"

    tags = [
      module.stg_app_vpc.public,
      "arbitera-stg-worker",
    ]

    disk_size_gb = var.k8s_worker_disk_size
    disk_type    = "pd-standard"
    preemptible  = false

    service_account = module.gke_service_account.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

# GCP service account for use by and attached to worker nodes
module "gke_service_account" {
  source = "../../modules/gke/modules/gke-service-account"

  name        = var.cluster_service_account_name
  project     = google_project.project.project_id
  description = var.cluster_service_account_description
}
