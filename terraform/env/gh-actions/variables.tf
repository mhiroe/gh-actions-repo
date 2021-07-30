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

variable "ssh_keys" {
  type    = string
  default = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHQIi1dR+GHaiY2zBas+X455CF/SL7PJiSyRp3cCL2t6AYPAq/XSMeLbYWYic9lz/jlI5enOuViniiZ05u8tpQTakGAetJb7X5x0AgesKxRT1tF/M5pRFpRy1Jb3jXL0GWTMWADkbHjk0nVB6uE4QnNpgHt35rcbMPUq/CuNK0TRWpmkEb4c4tlM637WqfZ6uw7nc+tssLua9NV27c+8oUPU//rd81o4cGLXoBZUgZ74V0oi0Qilf3xGfuci13YqmEg5nGJcw3Xv/eJrDG3Bl65jI+UzWPi7b2KljRs6Q2oSlww1JHFjQHZswzn4zVYYeLXZeBYA2blHT+0ssL8tql mitsuki.hiroe@O-07472-MAC.local
EOF
}
