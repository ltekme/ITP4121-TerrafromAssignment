terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

module "gcp-infra" {
  source = "./GCP-GKE-cluster"
  gcp_project = var.gcp_project
  gcp_region = var.gcp_region
  gcp_zone = var.gcp_zone
  db_password = ""
  db_username = ""
  domain_name = ""
}