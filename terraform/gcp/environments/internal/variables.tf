variable "credentials" {
  type        = "string"
  description = "Path to the GCP credentials to be used for deploying this environment"
  default     = "~/.config/gcloud/corpnavi-terraform-admin.json"
}

variable "host_project_name" {
  type        = "string"
  description = "The name of the host project"
  default     = "arbitera-internal"
}

variable "billing_account" {
  type        = "string"
  description = "Billing account for the host project. Should not change."
  default     = "01E24F-901626-0E053A"
}

variable "org_id" {
  type        = "string"
  description = "Arbitera top-level organisation ID. Should not change."
  default     = "222608296210"
}

variable "region" {
  type        = "string"
  description = "Host project region"
  default     = "asia-southeast1"
}

variable "project_services" {
  type        = list(string)
  description = "The services and APIs to enable for the host project. Defaults to minimal viable set for an Arbitera app environment."
  default = [
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "containerregistry.googleapis.com",
    "container.googleapis.com",
  ]
}

variable "public_restricted_whitelist" {
  type        = list(string)
  description = "A list of CIDR blocks from the public internet permitted to reach resources tagged public-restricted."
  default = [
    # IT's home IP.
    # TODO: should be VPN-only ingress.
    "112.199.240.233/32"
  ]
}

variable "vpc_cidr_primary" {
  description = "The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
  default     = "10.7.0.0/16"
}

variable "vpc_cidr_secondary" {
  type        = "string"
  description = "The CIDR block for the VPC secondary range. Must not overlap with stg or prod subnet range."
  default     = "10.8.0.0/16"
}

variable "oslogin_users" {
  type        = list(string)
  description = "Users/service accounts that should be given oslogin role"
  default = [
    "user:ian@corpnavi.com"
  ]
}
