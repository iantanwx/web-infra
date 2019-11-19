variable "credentials" {
  type        = "string"
  description = "Path to the GCP credentials to be used for deploying this environment"
  default     = "~/.config/gcloud/arbitera-tf-admin.json"
}

variable "billing_account" {
  type        = "string"
  description = "Billing account for the host project. Should not change."
  default     = "01F5A6-4C955D-CD5E15"
}

variable "org_id" {
  type        = "string"
  description = "Arbitera top-level organisation ID. Should not change."
  default     = "296410810676"
}

variable "region" {
  type        = "string"
  description = "Host project region"
  default     = "asia-southeast1"
}

variable "tf_project_name" {
  type        = "string"
  description = "The name of the Terraform master project used to manage the host project"
  default     = "arbitera-tf-admin"
}

variable "host_project_name" {
  type        = "string"
  description = "The name of the host project"
  default     = "arbitera-stg"
}

variable "internal_network" {
  type        = string
  description = "Self link of the internal vpc for peering"
  default     = null
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
  type        = "string"
  description = "The CIDR block for the VPC secondary range. Must not overlap with internal or prod subnet range."
  default     = "10.4.0.0/16"
}

variable "vpc_cidr_secondary" {
  type        = "string"
  description = "The CIDR block for the VPC secondary range. Must not overlap with internal or prod subnet range."
  default     = "10.5.0.0/16"
}

variable "oslogin_users" {
  type        = list(string)
  description = "Users/service accounts that should be given oslogin role"
  default = [
    "user:ian@corpnavi.com"
  ]
}

# k8s variables
variable "cluster_name" {
  type        = "string"
  description = "Name of the GKE cluster"
  default     = "arbitera-k8s-stg"
}

variable "master_cidr_block" {
  description = "The IP range in CIDR notation (size must be /28) to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  type        = string
  default     = "10.6.0.0/28"
}

variable "cluster_service_account_name" {
  default = "arbitera-stg-sa"
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "Example GKE Cluster Service Account managed by Terraform"
}

variable "k8s_initial_node_count" {
  type        = number
  description = "Initial number of worker nodes the cluster should start with"
  default     = 1
}

variable "k8s_min_node_count" {
  type        = number
  description = "Minimum number of nodes that should be in the cluster"
  default     = 1
}

variable "k8s_max_node_count" {
  type        = number
  description = "Maximum number of nodes that should be in the cluster"
  default     = 3
}

variable "k8s_worker_disk_size" {
  type        = number
  description = "Worker node disk size in gb"
  default     = 100
}

variable "helm_version" {
  type        = string
  description = "Image version for Tiller"
  default     = "v2.15.2"
}

variable "tiller_namespace" {
  type    = string
  default = "kube-system"
}
