provider "google" {
  region = var.region
  credentials = var.credentials
}

resource "random_id" "id" {
  byte_length = 4
  prefix      = "${var.host_project_name}-"
}

resource "google_project" "project" {
  name            = var.host_project_name
  project_id      = random_id.id.hex
  billing_account = var.billing_account
  org_id          = var.org_id
}

resource "google_project_services" "project" {
  project = google_project.project.project_id
  services = var.project_services
}

output "project_id" {
  value = google_project.project.project_id
}
