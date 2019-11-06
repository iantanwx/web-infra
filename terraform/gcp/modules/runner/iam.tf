# Service account for privileged runners.
# It has permissions for:
# - helm on staging/production
# - push/pull to gcr repositories
resource "google_service_account" "runner_privileged_sa" {
  project      = var.gcp_project
  account_id   = "runner-privileged-sa"
  display_name = "Privileged GitLab runner"
}

resource "google_service_account_key" "runner_privileged_sa_key" {
  service_account_id = google_service_account.runner_privileged_sa.name
}

# Service account for unprivileged runners.
# It has permissions for:
# - helm on staging/production
resource "google_service_account" "runner_unprivileged_sa" {
  project      = var.gcp_project
  account_id   = "runner-unprivileged-sa"
  display_name = "Unprivileged GitLab runner"
}

locals {
  gke_master_iam_member_set = setproduct(
    var.gke_projects,
    [google_service_account.runner_privileged_sa.email, google_service_account.runner_unprivileged_sa.email],
  )
}

# add kubernetes master access for privileged and unpriveleged SAs in all GKE cluster host projects
resource "google_project_iam_member" "runner_gke_admin" {
  count = length(local.gke_master_iam_member_set)

  project = local.gke_master_iam_member_set[count.index][0]
  member  = "serviceAccount:${local.gke_master_iam_member_set[count.index][1]}"
  role    = "roles/container.admin"
}

# add GCR read/write permissions on the privileged runner service account
resource "google_project_iam_member" "runner_gcr_admin" {
  project = var.gcp_project
  member  = "serviceAccount:${google_service_account.runner_privileged_sa.email}"
  role    = "roles/storage.admin"
}
