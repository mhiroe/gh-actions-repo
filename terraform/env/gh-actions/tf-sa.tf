# 権限の借用の検証
# refs
# これが完璧
# https://medium.com/google-cloud/a-hitchhikers-guide-to-gcp-service-account-impersonation-in-terraform-af98853ebd37

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
# https://cloud.google.com/iam/docs/creating-managing-service-accounts?hl=ja



# # default の gce 権限を借用する
# data "google_compute_default_service_account" "default" {
# }

# # Allow SA service account use the default GCE account
# resource "google_service_account_iam_member" "gce-default-account-iam" {
#   # 使えるリソース
#   service_account_id = data.google_compute_default_service_account.default.name
#   role               = "roles/iam.serviceAccountUser"
#   # 使う側
#   member = "serviceAccount:${google_service_account.sa-tfexc.email}"
#   depends_on = [
#     google_service_account.sa-tfexc
#   ]
# }


# # sa権限roleを ユーザーアカウントに付与する
# # add roles/iam.serviceAccountUser || roles/iam.serviceAccountTokenCreator || 
# resource "google_project_iam_member" "user-role-assa" {
#   project = var.basic.project
#   role    = "roles/iam.serviceAccountUser"
#   member  = "userAccount:mamoot@monyama.click"
# }
