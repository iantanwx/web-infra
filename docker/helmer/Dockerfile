FROM google/cloud-sdk:270.0.0

ARG KUBECTL_VERSION=1.16.0
ARG HELM_VERSION=2.14.3
ARG HELM_GCS_VERSION=0.2.2

RUN apt-get update && apt-get install -y ca-certificates bash curl

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl \
      && mv kubectl /usr/bin/ \
      && chmod +x /usr/bin/kubectl

RUN curl -L https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz|tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64

RUN mkdir -p $HOME/.helm/plugins

RUN helm plugin install https://github.com/hayorov/helm-gcs --version ${HELM_GCS_VERSION}

RUN helm init --client-only

