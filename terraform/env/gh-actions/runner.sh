## init ubuntu
sudo apt-get -y update;
sudo apt-get -y dist-upgrade ;


## download

# Create a folder
mkdir actions-runner && cd actions-runner# Download the latest runner package
curl -o actions-runner-linux-x64-2.279.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.279.0/actions-runner-linux-x64-2.279.0.tar.gz# Optional: Validate the hash
echo "50d21db4831afe4998332113b9facc3a31188f2d0c7ed258abf6a0b67674413a  actions-runner-linux-x64-2.279.0.tar.gz" | shasum -a 256 -c# Extract the installer
tar xzf ./actions-runner-linux-x64-2.279.0.tar.gz


## configure

# Create the runner and start the configuration experience
./config.sh --url https://github.com/mhiroe/gh-actions-repo --token ABAWB2RGEFSZBFDICNBGIQ3BAOMRO# Last step, run it!
./run.sh


# ## insatll service
# sudo ./svc.sh install
# sudo ./svc.sh start