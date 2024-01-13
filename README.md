# Homelab

## Table of Contents

- [Homelab](#homelab)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Folders](#folders)

## Description

This repository contains all of the configuration files and scripts I use to manage my homelab. I use a combination of Ansible, Docker, and Kubernetes to manage my homelab. I use Ansible to manage the configuration of my servers, Docker to run services, and Kubernetes to run services that require more than one container. I use Docker Compose to manage Docker containers and Helm/manifest.yaml files to manage Kubernetes resources.

## Folders

- .devcontainer: VSCode devcontainer configuration
- ansible: Ansible playbooks, roles, and inventories
- databases: Docker Compose files for databases used in my homelab
- docker: Docker Compose files for other services used in my homelab
- docs: Collection of Markdown files for documentation
- kubernetes: Kubernetes manifests, values files (for Helm), and other resources for any clusters I run
- scripts: Scripts for various tasks
- ssh: SSH configuration files such as keys and config files
- ssl: SSL certificates and keys (a small PKI)
