
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
  name = "runner-vpc"
}

resource "google_compute_subnetwork" "runner-subnet" {
  name          = "runner-subnet"
  ip_cidr_range = "192.168.10.0/24"
  network       = google_compute_network.runner-vpc.name
  region        = var.basic.region
}

# ## self-hosted-runner

# ## use module
# ## https://registry.terraform.io/modules/terraform-google-modules/github-actions-runners/google/latest/submodules/gh-runner-mig-vm
# module "github-actions-runners_gh-runner-mig-vm" {
#   source  = "terraform-google-modules/github-actions-runners/google//modules/gh-runner-mig-vm"
#   version = "1.0.0"
#   # insert the 5 required variables here
#   project_id = var.basic.project
#   gh_token   = "ABAWB2RGEFSZBFDICNBGIQ3BAOMRO" # persolnal userd
#   repo_name  = "gh-actions-repo"
#   repo_owner = "mhiroe"
#   repo_url   = "https://github.com/mhiroe/gh-actions-repo"

#   # optional variables
#   service_account = "sa-tf-monyama@gh-actions-321300.iam.gserviceaccount.com"
#   instance_name   = "runner-gce"
#   machine_type    = "f1-micro"
#   network         = google_compute_network.runner-vpc.name
#   subnetwork      = google_compute_subnetwork.runner-subnet.name
# }


# ## make my self
# resource "google_compute_instance" "gce-runner" {
#   name         = "gce-runner"
#   machine_type = "f1-micro"
#   zone         = var.basic.region

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-1804-bionic-v20210720"
#     }
#   }

#   metadata_startup_script = file("./init.sh")

#   network_interface {
#     subnetwork = "projects/[HostProjectName]/regions/us-west1/subnetworks/private-subnet01"
#     access_config {
#     }
#   }

#   network_interface {
#     network    = "${google_compute_network.runner-vpc.name}"
#     subnetwork = "${google_compute_subnetwork.runner-subnet.name}"
#     access_config {}
#   }

#     metadata {
#     "block-project-ssh-keys" = "true"
#     "sshKeys" = "${var.ssh_keys}"
#   }

# }
