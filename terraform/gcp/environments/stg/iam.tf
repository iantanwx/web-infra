module "oslogin_bindings" {
  source  = "../../modules/iam/project"
  project = google_project.project.project_id
  members = var.oslogin_users
  roles = [
    "roles/iam.serviceAccountUser",
    "roles/compute.osAdminLogin"
  ]
}
