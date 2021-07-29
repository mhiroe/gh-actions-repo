
terraform {
  required_version = "~> 0.14.3"

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
  ])
  service = each.value
}
