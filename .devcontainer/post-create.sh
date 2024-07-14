#!/bin/bash

# install requirements
pip3 install --user -r requirements.txt
pip3 install --user -r kubespray/requirements.txt

# install ansible-galaxy modules
modules=(ansible.posix)

for module in "${modules[@]}"; do
    ansible-galaxy collection install $module
done

export DEBIAN_FRONTEND=noninteractive && \ 
    sudo apt-get update && \
    sudo apt-get install -y \
        python3-paramiko \
    && sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

curl -s https://fluxcd.io/install.sh | sudo bash