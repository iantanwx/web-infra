# Create privileged runner instances.
resource "google_compute_instance" "runner_privileged" {
  count        = var.runner_privileged_count
  project      = var.gcp_project
  zone         = var.gcp_zone
  name         = "gitlab-ci-runner-${count.index + 1}"
  machine_type = var.runner_instance_type

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "gce-uefi-images/ubuntu-1804-lts"
      size  = "10"
      type  = "pd-standard"
    }
  }

  tags = var.runner_privileged_tags

  network_interface {
    subnetwork = var.subnetwork

    access_config {}
  }

  metadata_startup_script = <<SCRIPT
set -e
echo "Installing Docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get install -y docker-ce=${var.docker_version}

echo "Installing GitLab Runner"
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install -y gitlab-runner

echo "Setting GitLab concurrency"
sudo sed -i "s/concurrent = .*/concurrent = ${var.runner_concurrency}/" /etc/gitlab-runner/config.toml

echo "Registering GitLab CI runner with GitLab instance."
sudo gitlab-runner register \
    --non-interactive \
    --name "${google_compute_instance.runner_privileged[count.index].name}" \
    --url ${var.gitlab_url} \
    --registration-token ${var.runner_token} \
    --tag-list "${join(",", var.runner_privileged_tags)}"
    --executor "docker" \
    --docker-image alpine:latest \
    --docker-privileged \
    --run-untagged="true"

echo "GitLab Runner installation complete"
SCRIPT

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = google_service_account.runner_privileged_sa.email
    scopes = ["cloud-platform"]
  }
}
