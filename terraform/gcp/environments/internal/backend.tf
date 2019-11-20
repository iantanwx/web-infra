terraform {
  backend "gcs" {
    credentials = "~/.config/gcloud/arbitera-tf-admin.json"
    bucket      = "arbitera-tf-admin"
    prefix      = "terraform/internal/state"
  }
}
