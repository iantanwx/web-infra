data "google_client_config" "current" {}

provider "kubernetes" {
  version = "~> 1.9.0"
  # this is critical - it will attempt to use the currently set
  load_config_file       = false
  host                   = module.gke_cluster.endpoint
  token                  = data.google_client_config.current.access_token
  client_certificate     = module.gke_cluster.client_certificate
  client_key             = module.gke_cluster.client_key
  cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
}

provider "helm" {
  version         = "~> 0.10"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:${var.helm_version}"
  install_tiller  = true
  service_account = kubernetes_service_account.tiller_service_account.metadata[0].name
  namespace       = var.tiller_namespace
  # TODO: use TLS for helm-tiller communication when there is a better solution than kubegrunt.
  enable_tls = false

  kubernetes {
    host                   = module.gke_cluster.endpoint
    token                  = data.google_client_config.current.access_token
    client_certificate     = module.gke_cluster.client_certificate
    client_key             = module.gke_cluster.client_key
    cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
  }
}

resource "kubernetes_service_account" "tiller_service_account" {
  metadata {
    name      = "tiller"
    namespace = var.tiller_namespace
  }
}

resource "kubernetes_cluster_role_binding" "cluster_admin" {
  metadata {
    name = "gke-admin"
  }

  # TODO: tiller should not have cluster-admin. it should be limited to namespaces.
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tiller_service_account.metadata[0].name
    namespace = var.tiller_namespace
  }
}

# Workaround: tiller will not be installed without a helm release!
# see https://github.com/terraform-providers/terraform-provider-helm/issues/148
resource "helm_release" "redis" {
  name  = "redis"
  chart = "stable/redis"
}
