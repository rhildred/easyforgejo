#!/bin/bash

#set -ex

sudo service forgejo-runner stop || true

sudo userdel runner || true
sudo useradd --create-home runner

ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')

echo "4. Downloading Forgejo Runner binary..."
RUNNER_VERSION=$(curl -s https://data.forgejo.org/api/v1/repos/forgejo/runner/releases/latest | grep -o '"tag_name":"[^"]*"' | cut -d\" -f4)
echo "   - Runner Version: $RUNNER_VERSION"
cd /tmp
wget -O forgejo-runner.xz "https://code.forgejo.org/forgejo/runner/releases/download/${RUNNER_VERSION}/forgejo-runner-${RUNNER_VERSION#v}-linux-${ARCH}.xz"
unxz -f --keep forgejo-runner.xz
chmod +x forgejo-runner

# Install Runner binary
echo "5. Installing Forgejo Runner binary..."
sudo cp forgejo-runner /usr/local/bin/forgejo-runner
forgejo-runner --version
