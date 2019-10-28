provider "google" {
  region      = var.region
  credentials = var.credentials
}

provider "google-beta" {
  region      = var.region
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

resource "google_project_service" "service_apis" {
  project                    = google_project.project.project_id
  for_each                   = toset(var.project_services)
  service                    = each.value
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "google_compute_project_metadata_item" "enable_oslogin" {
  project = google_project.project.project_id
  key     = "enable-oslogin"
  value   = "TRUE"
}

output "project_id" {
  value = google_project.project.project_id
}
