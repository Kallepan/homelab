#!/bin/bash

SSH_KEY_PATH=~/.ssh/id_rsa
KUBECONFIG_PATH=~/.kube/config

GIT_REPO=ssh://git@github.com/Kallepan/homelab

BRANCH=main
PATH=clusters/production

flux --kubeconfig=${KUBECONFIG_PATH} bootstrap git \
    --url=${GIT_REPO} \
    --private-key-file=${SSH_KEY_PATH} \
    --branch=${BRANCH} \
    --path=${PATH}
