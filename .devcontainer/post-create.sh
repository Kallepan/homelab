#!/bin/bash

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