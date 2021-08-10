terraform {
  required_version = "~> 0.13.6"

  backend "gcs" {
    bucket = "actions-tfstate"
    prefix = "terraform/state"
  }
}


#
# prepare provider for token
#

provider "google" {
  alias = "tokengen"
}

data "google_client_config" "default" {
  provider = google.tokengen
}


#
# my user account
#

# ユーザーに最小限のroleを与える
# 持っていないといけない権限
# backend gcsバケットの edit権限
# iam.serviceAccounts.get
# serviceusage.services.use
# iam.serviceAccounts.getIamPolicy
resource "google_project_iam_member" "my-minimum-role" {
  project = var.basic.project

  for_each = toset([
    "roles/serviceusage.serviceUsageConsumer",
    "roles/iam.serviceAccountUser",
    "roles/viewer",
  ])

  role   = each.value
  member = "user:mamoot@monyama.click"
}


#
# sa sattings
#

resource "google_service_account" "sa-tfexc" {
  provider   = google.tokengen
  account_id = "sa-tfexec"
  project    = var.basic.project
}

# sa に editor の権限を付与する
resource "google_project_iam_member" "sa-tcexec-role" {
  provider = google.tokengen
  project  = var.basic.project

  for_each = toset([
    "roles/editor",
    # "roles/iam.serviceAccountAdmin",
    # "roles/resourcemanager.projectIamAdmin",
  ])
  role   = each.value
  member = "serviceAccount:${google_service_account.sa-tfexc.email}"

  depends_on = [
    google_service_account.sa-tfexc
  ]
}

# sa に ユーザーを追加する (roles impersonate)
resource "google_service_account_iam_member" "sa-tfexec-member" {
  provider = google.tokengen

  service_account_id = google_service_account.sa-tfexc.name

  role   = "roles/iam.serviceAccountTokenCreator"
  member = "user:mamoot@monyama.click"
  depends_on = [
    google_service_account.sa-tfexc
  ]
}

#
# create token
#

# 権限の借用を有効にしたsaのtokenの有効期限を設定する
data "google_service_account_access_token" "sa" {
  provider               = google.tokengen
  target_service_account = google_service_account.sa-tfexc.email
  lifetime               = "600s"
  # scopes                 = ["cloud-platform"]
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

# tokenを使って default providerを設定
provider "google" {
  access_token = data.google_service_account_access_token.sa.access_token
  project      = var.basic.project
  region       = var.basic.region
}

# 適当なgcs 権限の借用 テスト用
resource "google_storage_bucket" "test" {
  name     = "my-project-id-test-bucket"
  location = "us-west1"
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



## gh actions self-hosted-runner

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
