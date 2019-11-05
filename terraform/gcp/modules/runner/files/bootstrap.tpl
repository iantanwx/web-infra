#!/bin/bash

set -e
echo "Installing Docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get install -y docker-ce=${docker_version}

echo "Installing GitLab Runner"
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install -y gitlab-runner

echo "Setting GitLab concurrency"
sed -i "s/concurrent = .*/concurrent = ${var.runner_concurrency}/" /etc/gitlab-runner/config.toml

echo "Registering GitLab CI runner with GitLab instance."
sudo gitlab-runner register \
    --non-interactive \
    --name "gcp-${var.gcp_project}" \
    --url ${var.gitlab_url} \
    --registration-token ${var.runner_token} \
    --tag-list "${var.runner_privileged_tags}"
    --executor "docker" \
    --docker-privileged

echo "GitLab CI Runner installation complete"
