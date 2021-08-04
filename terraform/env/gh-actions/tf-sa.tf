resource "google_service_account" "sa-tfexc" {
  account_id = "sa-tfexec"
  project    = var.basic.project
}

