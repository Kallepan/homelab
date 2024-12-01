#!/bin/bash
set -eu -o pipefail

# Install ansible
pipx install --include-deps ansible
pipx inject ansible ansible-lint
pipx inject ansible ansible-pylibssh

# install ansible-galaxy modules
modules=(ansible.posix)

for module in "${modules[@]}"; do
    ansible-galaxy collection install $module
done

# Install flux
curl -s https://fluxcd.io/install.sh | sudo bash

# Install argocd
VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
curl -sSL -o argocd-darwin-arm64 https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-arm64
sudo install -m 555 argocd-darwin-arm64 /usr/local/bin/argocd
rm argocd-darwin-arm64

# Install talosctl
curl -sL https://talos.dev/install | sh

# Install clusterctl
curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.8.5/clusterctl-linux-arm64 -o clusterctl
sudo install -o root -g root -m 0755 clusterctl /usr/local/bin/clusterctl