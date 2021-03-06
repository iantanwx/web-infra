variable "gcp_project" {
  type        = string
  description = "The GCP project to deploy the runner into."
}

variable "gcp_zone" {
  type        = string
  description = "The GCP zone to deploy the runner into."
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to deploy into"
}

variable "gke_projects" {
  type        = list(string)
  description = "The GCP projects in which the runner should have GKE master access."
}

variable "gitlab_url" {
  type        = string
  description = "The URL of the GitLab server hosting the projects to be built."
  default     = "https://gitlab.com"
}

variable "docker_version" {
  type        = string
  description = "The docker version to use."
  default     = "18.06.3~ce~3-0~ubuntu"
}

variable "docker_image" {
  type        = string
  description = "Default docker image to use for runner jobs"
  default     = "gcr.io/arbitera-internal-9c7092e2/gitlab-runner:0.1.0"
}

variable "runner_privileged_count" {
  type        = number
  description = "The number of privileged runners to deploy."
  default     = 1
}

variable "runner_privileged_tags" {
  type        = list(string)
  description = "A list of tags to attach to privileged runners. Used to determine ingress."
  default     = ["ssh", "runner-privileged"]
}

variable "runner_unprivileged_count" {
  type        = number
  description = "The number of unprivileged runners to deploy."
  default     = 1
}

variable "runner_unprivileged_tags" {
  type        = list(string)
  description = "A list of tags to attach to privileged runners. Used to determine ingress."
  default     = ["ssh", "runner-unprivileged"]
}

variable "runner_token" {
  type        = string
  description = "The runner registration token obtained from GitLab."
}

variable "runner_instance_type" {
  type        = string
  description = "The size of the runner instances."
  default     = "n1-standard-1"
}

variable "runner_concurrency" {
  type        = number
  default     = 1
  description = "The maximum number of concurrent jobs permitted per runner."
}

variable "runner_image" {
  type        = string
  default     = "docker:stable"
  description = "The runner image to use for builds"
}
