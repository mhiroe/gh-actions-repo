# variable "project" {
#   type    = string
#   default = "dena-desc-du-pf-prod-gcp"
# }

# variable "region" {
#   type    = string
#   default = "asia-northeast1"
# }

variable "basic" {
  type = map(any)
  default = {
    project = "gh-actions-321300",
    region  = "us-west1"
    zone    = "us-west1-a"
  }
}
