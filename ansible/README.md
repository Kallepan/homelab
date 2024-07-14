# Ansible

## Prerequisites

- Start up the devcontainer which will install all the necessary tools and dependencies.

## Running the playbook

- Run the following command to execute a playbook, e.g. `common.yml`:

```bash
ansible-playbook -i inventory/hosts.yaml --become --become-user=root playbooks/common.yml
```

## Inventory

- The inventory file is located at `inventory/hosts.yaml`.

## Playbooks

Currently, the following playbooks are available:

- `common.yml`: Installs common packages and tools, setup ssl certificates, and configure the ssh daemon.
- `docker.yml`: Installs (rootless) Docker and Docker Compose
- `dhcp.yml`: Renews dhcp leases
- `rancher.yml`: Installs Rancher using rke2
- `shutdown.yml`: Shuts down the machine
- `ssl.yml`: Installs SSL certificates
