/**
 * Copyright 2019 Mantel Group Pty Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "runner_project" {
  type        = string
  description = "The GCP project to deploy the runner into."
}

variable "gke_projects" {
  type = list(string)
  description = "The GCP projects in which the runner should have GKE master access."
}

variable "gcp_zone" {
  type        = string
  description = "The GCP zone to deploy the runner into."
}

variable "gitlab_url" {
  type        = string
  description = "The URL of the GitLab server hosting the projects to be built."
  default = "https://gitlab.com"
}

variable "runner_privileged_count" {
  type = number
  description = "The number of privileged runners to deploy."
  default = 1
}

variable "runner_unprivileged_count" {
  type = number
  description = "The number of unprivileged runners to deploy."
  default = 1
}

variable "runner_token" {
  type        = string
  description = "The runner registration token obtained from GitLab."
}

variable "runner_instance_type" {
  type        = string
  description = "The size of the runner instances."
  default     = "f1-micro"
}

variable "runner_concurrency" {
  type        = number
  default     = 1
  description = "The maximum number of concurrent jobs permitted per runner."
}
