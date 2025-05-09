data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = var.cluster-endpoint
  cluster_ca_certificate = var.cluster-ca
  token                  = var.cluster-token
}

