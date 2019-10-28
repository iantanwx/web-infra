module "oslogin_bindings" {
  source  = "../../modules/iam/project"
  project = google_project.project.project_id
  members = var.oslogin_users
  roles = [
    "roles/iam.serviceAccountUser",
    "roles/compute.osAdminLogin"
  ]
}

resource "google_service_account" "k8s_admin" {
  project = google_project.project.project_id
  account_id = "k8s-admin"
  display_name = "Kubernetes administrator"
}

resource "google_project_iam_binding" "k8s_admin" {
  project = google_project.project.project_id
  members = [
    "serviceAccount:${google_service_account.k8s_admin.email}"
  ]
  role = "roles/container.admin"
}
