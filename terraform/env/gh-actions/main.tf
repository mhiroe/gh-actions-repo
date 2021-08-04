
terraform {
  required_version = "~> 0.13.6"

  backend "gcs" {
    bucket = "actions-tfstate"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.basic.project
  region  = var.basic.region
}

resource "google_project_service" "enable-services" {
  project                    = var.basic.project
  disable_dependent_services = true

  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "iam.googleapis.com",
    "storage-component.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "secretmanager.googleapis.com",
  ])
  service = each.value
}


# network settings
resource "google_compute_network" "runner-vpc" {
  # auto_create_subnetworks         = false
  delete_default_routes_on_create = false
  name                            = "runner-vpc"
  mtu                             = 0
  routing_mode                    = "REGIONAL"
}

resource "google_compute_subnetwork" "runner-subnet" {
  name          = "runner-subnet"
  ip_cidr_range = "192.168.10.0/24"
  network       = google_compute_network.runner-vpc.name
  region        = var.basic.region
}

## self-hosted-runner

## scratch runner
resource "google_compute_instance" "gce-runner" {
  name         = "gce-runner"
  machine_type = "f1-micro"
  zone         = var.basic.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20210720"
    }
  }

  network_interface {
    network    = google_compute_network.runner-vpc.name
    subnetwork = google_compute_subnetwork.runner-subnet.name
    access_config {}
  }

  metadata_startup_script = file("./runner.sh")

  metadata = {
    "block-project-ssh-keys" = "true"
    "sshKeys"                = var.ssh_keys
  }

}
