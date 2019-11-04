# Create privileged runner instances.
resource "google_compute_instance" "runner_privileged" {
  project      = var.runner_project
  name         = "gitlab-ci-runner"
  machine_type = var.runner_instance_type
  zone         = var.gcp_zone

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "10"
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<SCRIPT
set -e

echo "Installing GitLab CI Runner"
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
sudo yum install -y gitlab-runner

echo "Installing docker machine."
curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-Linux-x86_64 -o /tmp/docker-machine
sudo install /tmp/docker-machine /usr/local/bin/docker-machine

echo "Verifying docker-machine and generating SSH keys ahead of time."
docker-machine create --driver google \
    --google-project ${var.gcp_project} \
    --google-machine-type f1-micro \
    --google-zone ${var.gcp_zone} \
    --google-service-account ${google_service_account.ci_worker.email} \
    --google-scopes https://www.googleapis.com/auth/cloud-platform \
    test-docker-machine

docker-machine rm -y test-docker-machine

echo "Setting GitLab concurrency"
sed -i "s/concurrent = .*/concurrent = ${var.ci_concurrency}/" /etc/gitlab-runner/config.toml

echo "Registering GitLab CI runner with GitLab instance."
sudo gitlab-runner register -n \
    --name "gcp-${var.gcp_project}" \
    --url ${var.gitlab_url} \
    --registration-token ${var.ci_token} \
    --executor "docker+machine" \
    --docker-image "alpine:latest" \
    --machine-idle-time ${var.ci_worker_idle_time} \
    --machine-machine-driver google \
    --machine-machine-name "gitlab-ci-worker-%s" \
    --machine-machine-options "google-project=${var.gcp_project}" \
    --machine-machine-options "google-machine-type=${var.ci_worker_instance_type}" \
    --machine-machine-options "google-zone=${var.gcp_zone}" \
    --machine-machine-options "google-service-account=${google_service_account.ci_worker.email}" \
    --machine-machine-options "google-scopes=https://www.googleapis.com/auth/cloud-platform"

echo "GitLab CI Runner installation complete"
SCRIPT

  service_account {
    email  = google_service_account.ci_runner.email
    scopes = ["cloud-platform"]
  }
}
