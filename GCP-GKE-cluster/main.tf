resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = var.gcp_region

  initial_node_count = 1
}

resource "google_container_node_pool" "node_pool" {
  name       = "node-pool"
  location   = var.gcp_region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }

  node_config {
    machine_type = "e2-micro"
    disk_size_gb = 50

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_sql_database_instance" "main" {
  name             = "main-instance"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true

    }
  }
}

resource "google_sql_user" "default" {
  name     = "itp4121"
  instance = google_sql_database_instance.main.name
  password = "itp4121-admin"
}

data "google_client_config" "provider" {}
