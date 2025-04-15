module "gcp" {
  source = "./modules/gcp"
  gcp_project = var.gcp_project
  region  = var.gcp_region

}

module "cluster" {
  source = "./modules/cluster"

}

resource "google_container_node_pool" "node_pool" {
  name       = "node-pool"
  location   = var.gcp_region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-micro"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# kubernetes
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

resource "kubernetes_secret" "db_credentials" {
  metadata {
    name = "postgres-credentials"
  }

  data = {
    username = var.db_username
    password = var.db_password
  }
}

resource "kubernetes_stateful_set" "postgres" {
  metadata {
    name = "postgres"
  }

  spec {
    service_name = "postgres"
    replicas     = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:13"

          env_from {
            secret_ref {
              name = kubernetes_secret.db_credentials.metadata[0].name
            }
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "postgres-storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "500Mi"
          }
        }
      }
    }
  }
}

# ingress
resource "kubernetes_ingress_v1" "main" {
  metadata {
    name = "main-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.ingress_ip.name
      "networking.gke.io/managed-certificates"      = google_compute_managed_ssl_certificate.default.name
    }
  }

  spec {
    rule {
      host = var.domain_name
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "frontend-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "app-cert"

  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_global_address" "ingress_ip" {
  name = "ingress-ip"
}

# dns.tf
resource "google_dns_managed_zone" "default" {
  name        = "app-zone"
  dns_name    = "${var.domain_name}."
  description = "Application DNS zone"
}

resource "google_dns_record_set" "frontend" {
  name         = google_dns_managed_zone.default.dns_name
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.default.name
  rrdatas      = [google_compute_global_address.ingress_ip.address]
}

# cdn.tf
resource "google_compute_backend_bucket" "static" {
  name        = "static-asset-backend"
  bucket_name = google_storage_bucket.static.name
  enable_cdn  = true
}

resource "google_storage_bucket" "static" {
  name          = "static-assets-${var.gcp_project}"
  location      = "asia-east2"
  force_destroy = true
}

