locals {
  oslogin_users = [
    "user:ian@arbitera.io",
    "serviceAccount:${module.gitlab_runner.privileged_sa}",
    "serviceAccount:${module.gitlab_runner.unprivileged_sa}"
  ]
}

module "oslogin_bindings" {
  source  = "../../modules/iam/project"
  project = google_project.project.project_id
  members = local.oslogin_users
  roles = [
    "roles/iam.serviceAccountUser",
    "roles/compute.osAdminLogin"
  ]
}

resource "google_service_account" "k8s_admin" {
  project      = google_project.project.project_id
  account_id   = "k8s-admin"
  display_name = "Kubernetes administrator"
}

resource "google_project_iam_member" "k8s_admin" {
  project = var.stg_project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.k8s_admin.email}"
}
