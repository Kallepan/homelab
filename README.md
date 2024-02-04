# Homelab

## Table of Contents

- [Homelab](#homelab)
  - [Table of Contents](#table-of-contents)
  - [Networks](#networks)
  - [Description](#description)
  - [Folders](#folders)

## Networks

- 10.0.0.0/16: `lan-0`
- 10.1.0.0/16: `lan-1`
- 172.16.0.0/12: `internal` not provisioned yet

## Description

This repository contains all of the configuration files and scripts I use to manage my homelab. I use a combination of Ansible, Docker, and Kubernetes to manage my homelab. I use Ansible to manage the configuration of my servers, Docker to run services, and Kubernetes to run services that require more than one container. I use Docker Compose to manage Docker containers and Helm/manifest.yaml files to manage Kubernetes resources.

## Folders

- .devcontainer: VSCode devcontainer configuration
- ansible: Ansible playbooks, roles, and inventories
- clusters: Kubernetes cluster configuration files used by Flux to manage clusters
- docker: Docker Compose files for services running on docker (e.g. databases, apps)
- docs: Collection of Markdown files for documentation
- kubernetes: Kubernetes manifests, values files (for Helm) and flux gitops configuration
- scripts: Scripts for various tasks
- ssh: SSH configuration files such as keys and config files
- ssl: SSL certificates and keys (a small PKI)
