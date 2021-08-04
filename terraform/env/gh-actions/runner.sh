## init ubuntu
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y install unzip jq


## download

# Create a folder
mkdir ~/actions-runner && cd ~/actions-runner 
# Download the latest runner package
curl -o actions-runner-linux-x64-2.279.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.279.0/actions-runner-linux-x64-2.279.0.tar.gz 
# Optional: Validate the hash
echo "50d21db4831afe4998332113b9facc3a31188f2d0c7ed258abf6a0b67674413a  actions-runner-linux-x64-2.279.0.tar.gz" | shasum -a 256 -c  
# Extract the installer
tar xzf ./actions-runner-linux-x64-2.279.0.tar.gz

# run svc.sh manually

# see below
# https://github.com/mhiroe/gh-actions-repo/settings/actions/runners
# https://qiita.com/sakas1231/items/567ea9bdc1d4ac9f8696


# svc.sh runs as daemon
# https://docs.github.com/ja/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service
# cant daemonize with "." user name