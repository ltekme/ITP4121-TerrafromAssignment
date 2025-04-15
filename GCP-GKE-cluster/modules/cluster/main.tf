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
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-micro"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

