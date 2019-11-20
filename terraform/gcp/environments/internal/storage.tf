resource "google_storage_bucket" "arbitera-helm-repo" {
  project  = google_project.project.project_id
  name     = "arbitera-helm-repo"
  location = "asia"

  versioning {
    enabled = true
  }
}

# Grant GKE cluster read-only access to GCR
resource "google_storage_bucket_iam_member" "gcr-ro" {
  bucket = "artifacts.${google_project.project.project_id}.appspot.com"
  member = "serviceAccount:${var.stg_gke_sa}"
  role   = "roles/storage.objectViewer"
}

resource "google_storage_bucket_iam_binding" "helm-repo-rw" {
  bucket = google_storage_bucket.arbitera-helm-repo.name
  members = [
    "serviceAccount:${module.gitlab_runner.privileged_sa}",
    "serviceAccount:${module.gitlab_runner.unprivileged_sa}",
  ]

  role = "roles/storage.objectAdmin"
}
