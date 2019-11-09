resource "google_storage_bucket" "arbitera-helm-repo" {
  project = google_project.project.id
  name = "arbitera-helm-repo"
  location = "asia"

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_binding" "helm-repo-rw" {
  bucket = google_storage_bucket.arbitera-helm-repo.name
  members = [
    "serviceAccount:${module.gitlab_runner.privileged_sa}",
    "serviceAccount:${module.gitlab_runner.unprivileged_sa}",
  ]

  role = "roles/storage.objectAdmin"
}
