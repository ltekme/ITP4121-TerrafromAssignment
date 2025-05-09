module "GCP-Infra" {
  source      = "./GCP-GKE-cluster"
  gcp_project = var.gcp_project
  gcp_region  = var.gcp_region
}

module "GCP-K8s" {
  source           = "./k8s"
  cluster-endpoint = module.gcp-infra.cluster.endpoint
  cluster-ca       = base64decode(module.gcp-infra.cluster.master_auth.0.cluster_ca_certificate)
  cluster-token    = module.gcp-infra.access-token
}
