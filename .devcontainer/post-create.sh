#!/bin/bash

export DEBIAN_FRONTEND=noninteractive && \
    sudo apt-get update && \
    sudo apt-get install -y \
        python3-pip \
        pipx \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/*

# install requirements
pipx install --include-deps ansible
pip3 install --user -r requirements.txt
pip3 install --user -r kubespray/requirements.txt

# install ansible-galaxy modules
modules=(ansible.posix)

for module in "${modules[@]}"; do
    ansible-galaxy collection install $module
done

curl -s https://fluxcd.io/install.sh | sudo bash