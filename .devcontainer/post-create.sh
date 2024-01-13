#!/bin/bash

# install kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /usr/share/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/kubernetes.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update \
    && apt-get install -y kubectl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ansible requirements.txt
pip3 install -r ansible/requirements.txt