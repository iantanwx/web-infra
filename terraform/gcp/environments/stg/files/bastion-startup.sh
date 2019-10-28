#! /bin/bash

# install kubectl
function install_kubectl() {
  sudo apt-get update && sudo apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
}

function install_terraform() {
  [[ -f ${HOME}/bin/terraform ]] && echo "`${HOME}/bin/terraform version` already installed at ${HOME}/bin/terraform" && return 0
  OS=$(uname -s)
  LATEST_VERSION=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].version' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'alpha|beta|rc' | tail -1)
  LATEST_URL="https://releases.hashicorp.com/terraform/${LATEST_VERSION}/terraform_${LATEST_VERSION}_${OS,,}_amd64.zip"
  curl ${LATEST_URL} > "${HOME}"/terraform.zip
  mkdir -p ${HOME}/bin
  (cd ${HOME}/bin && unzip "${HOME}"/terraform.zip)
  if [[ -z $(grep 'export PATH=${HOME}/bin:${PATH}' ~/.bashrc 2>/dev/null) ]]; then
  	echo 'export PATH=${HOME}/bin:${PATH}' >> ~/.bashrc
  fi

  echo "Installed: `${HOME}/bin/terraform version`"
  rm -rf "${HOME}"/terraform.zip

  cat - << EOF

Run the following to reload your PATH with terraform:
  source ~/.bashrc
EOF
}

function install_deps() {
  sudo apt-get update
  sudo apt-get install -y jq unzip
}

function bootstrap() {
  install_deps
  install_kubectl
  install_terraform
}

bootstrap
