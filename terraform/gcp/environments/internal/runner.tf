module "gitlab_runner" {
  source       = "../../modules/runner"
  gcp_project  = google_project.project.project_id
  gcp_zone     = "asia-southeast1-a"
  gke_projects = [var.stg_project_id]
  runner_token = var.gitlab_runner_token
  subnetwork   = module.internal_vpc.public_subnetwork
}
