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


- セルフホストランナーの追加 (公式の手順)
  - https://docs.github.com/ja/actions/hosting-your-own-runners/adding-self-hosted-runners


## startup script
手を加えると インスタンス作り直しになるのでここで..

# ssh runner-host
# sudo su -
# cd /root/actions-runner
# RUNNER_ALLOW_RUNASROOT=1 /runner/config.sh --unattended --replace --work "/runner-tmp" --url "$REPO_URL" --token "$ACTIONS_RUNNER_INPUT_TOKEN"
# #install and start runner service
# cd /runner || exit
# ./svc.sh install
# ./svc.sh start

# ここ参考に修正する
# https://github.com/terraform-google-modules/terraform-google-github-actions-runners/blob/v1.0.0/modules/gh-runner-mig-vm/scripts/startup.sh
