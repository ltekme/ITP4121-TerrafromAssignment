data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

resource "kubernetes_secret" "db_credentials" {
  metadata {
    name = "db-credentials"
  }

  data = {
    username = var.db_username
    password = var.db_password
  }
}

resource "google_sql_database_instance" "db_instance" {
  name             = "db-instance"
  database_version = "POSTGRES_15"
  region           = var.gcp_region

  settings {
    tier = "db-f1-micro"
  }
}

/* ingress
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

# dns
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

# cdn
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
*/

