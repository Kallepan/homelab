#!/bin/bash
set -eu -o pipefail

# install requirements
pipx install --include-deps ansible
pipx install --include-deps ansible-lint
pipx install --include-deps ansible-pylibssh

# install ansible-galaxy modules
modules=(ansible.posix)

for module in "${modules[@]}"; do
    ansible-galaxy collection install $module
done

# Install flux
curl -s https://fluxcd.io/install.sh | sudo bash

# Install ArgoCD
VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
curl -sSL -o argocd-darwin-arm64 https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-arm64
sudo install -m 555 argocd-darwin-arm64 /usr/local/bin/argocd
rm argocd-darwin-arm64