# gh-actions-repo

terraform cloud(enterprise) つかわない
https://medium.com/interleap/automating-terraform-deployment-to-google-cloud-with-github-actions-17516c4fb2e5
-> いけた

## runner

- gce multi instance group を使う
  https://registry.terraform.io/modules/terraform-google-modules/github-actions-runners/google/latest/submodules/gh-runner-mig-vm

  - gce 動かす sa に 権限を付与してしまっている

- k8s を使う
  https://tech.jxpress.net/entry/gitops-for-terraform-with-github-self-hosted-runner
  - https://github.com/bharathkkb/gh-runners/tree/master/gke

