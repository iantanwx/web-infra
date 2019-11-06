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

echo "Setting GitLab runner config"
echo '${data.template_file.privileged_runner_config.rendered}' | sudo tee /etc/gitlab-runner/config.toml 1>/dev/null

echo "Setting up gcloud service account credentials"
sudo mkdir -p /etc/creds
echo "${base64decode(google_service_account_key.runner_privileged_sa_key.private_key)}" | sudo tee /etc/creds/gcp_credentials.json 1>/dev/null

echo "Registering GitLab CI runner with GitLab instance."
sudo gitlab-runner register \
    --non-interactive \
    --name "gitlab-ci-runner-${count.index + 1}" \
    --url "${var.gitlab_url}" \
    --registration-token "${var.runner_token}" \
    --tag-list "${join(",", var.runner_privileged_tags)}" \
    --executor "docker" \
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

provider "template" {
  version = "~>2.1"
}

data "template_file" "privileged_runner_config" {
  template = file("${path.module}/files/config.tpl")
  vars = {
    concurrency = var.runner_concurrency
    url = var.gitlab_url
    token = var.runner_token
    runner_image = var.runner_image
    privileged = true
  }
}
