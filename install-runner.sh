#!/bin/bash

#set -ex

# Parse command-line arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <FORGEJO_URL> <RUNNER_SECRET>"
    echo "Example: $0 https://dev.k3p.io 7c31591e8b67225a116d4a4519ea8e507e08f71f"
    exit 1
fi

export FORGEJO_URL="$1"
export RUNNER_SECRET="$2"

echo "Configuration:"
echo "  FORGEJO_URL: $FORGEJO_URL"
echo "  RUNNER_SECRET: $RUNNER_SECRET"
echo ""

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
