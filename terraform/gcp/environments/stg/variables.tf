variable "credentials" {
  type = "string"
  description = "Path to the GCP credentials to be used for deploying this environment"
  default = "~/.config/gcloud/corpnavi-terraform-admin.json"
}

variable "host_project_name" {
  type = "string"
  description = "The name of the host project"
  default = "arbitera-stg"
}

variable "billing_account" {
  type = "string"
  description = "Billing account for the host project. Should not change."
  default = "01E24F-901626-0E053A"
}

variable "org_id" {
  type = "string"
  description = "Arbitera top-level organisation ID. Should not change."
  default = "222608296210"
}

variable "region" {
  type = "string"
  description = "Host project region"
  default = "asia-southeast1"
}

variable "project_services" {
  type = list(string)
  description = "The services and APIs to enable for the host project. Defaults to minimal viable set for an Arbitera app environment."
  default = [
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
  ]
}
