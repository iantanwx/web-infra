variable "auth_file" {
  description = "The configuration file containing the credentials to connect to google"
}

variable "image" {
  description = "The image to use for the instance"
  default = "ubuntu-1604-xenial-v20170330"
}
variable "network" {
  description = "The network for the instance to live on"
  default = "default"
}

variable "region" {
  description = "The region this all lives in. TODO can this be inferred from zone or vice versa?"
  default = "us-central1"
}

variable "zone" {
  description = "The zone to deploy the machine to"
  default = "us-central1-a"
}

variable "dns_name" {
  description = "The DNS name of the GitLab instance."
}

variable "dns_zone" {
  description = "The name of the DNS zone in Google Cloud that the DNS name should go under"
  default = "no_dns"
}

variable "project" {
  description = "The project in Google Cloud to create the GitLab instance under"
}

variable "ssh_key" {
  description = "The ssh key to use to connect to the Google Cloud Instance"
  default = "~/.ssh/id_rsa"
}

variable "ssl_certificate" {
  description = "The SSL certificate file to use"
  default = "/dev/null"
}

variable "prefix" {
  description = "Prefix to resource names in cloud provider"
}

variable "runner_count" {
  description = "Number of GitLab CI Runners to create."
  default = 1
}

variable "runner_host" {
  description = "URL of the GitLab server Runner will register with"
  default = "GENERATE"
}

variable "runner_token" {
  description = "GitLab CI Runner registration token."
}

variable "runner_disk_size" {
  description = "Size of disk (in GB) for Runner instances"
  default = 20
}

variable "runner_image" {
  description = "The Docker image a GitLab CI Runner will use by default"
  default = "ruby:2.3"
}

variable "runner_machine_type" {
  description = "A machine type for your compute instance, used by GitLab CI Runner"
  default = "n1-standard-1"
}
