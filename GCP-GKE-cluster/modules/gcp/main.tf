provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  #zone    = var.gcp_zone
}

#Create vpc with 2 private subnets
resource "google_compute_network" "vpc" {
  name = "gcp-vpc"
}

resource "google_compute_subnetwork" "private_subnet1" {
  name                     = "private-subnet-1"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = var.gcp_region
  network                  = google_compute_network.vpc.name
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_subnet2" {
  name          = "private-subnet-2"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc.name
}

#Create vm instance
resource "google_compute_instance" "vm_instance" {
  name         = "vm-instance"
  machine_type = "e2-micro"
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private_subnet1.name
    access_config {
      # No external IP
    }
  }
}

