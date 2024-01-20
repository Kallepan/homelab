# Flux System

This directory contains the Flux system components for the cluster. Flux is a tool that automatically ensures that the state of a cluster matches the config in this repo. It uses an operator in the cluster to trigger deployments inside Kubernetes, which means you don't need a separate CD tool. It monitors all relevant image repositories, detects new images, triggers deployments and updates the desired running configuration based on that (and a configurable policy).

## Setup

### Prerequisites

- Create the repository in GitLab (in my case I have a self hosted instance)
- Create a PAT (Personal Access Token) with `api` scope or read write access to the repository
- Ensure the k3s cluster is up and running and the kubeconfig is available (k3s.yaml)

### Install Flux

The following command will create the namespace and install the basic Flux components

```bash
flux bootstrap git \
    --kubeconfig=.kube/k3s.yaml \
    --components-extra=image-reflector-controller,image-automation-controller \
    --branch=main \
    --url=https://gitlab.srv-k8s.server.io/kalle/clusters.git \
    --username=kalle \
    --password=CHANGME \
    --token-auth=true \
    --path=clusters/cluster-2 \
    --ca-file=Dev/homelab/ssl/intermediateCA/certs/ca-chain.cert.pem
```