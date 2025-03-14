# Homelab Setup GitOps Repository

This repository contains the configuration files for my homelab setup. The setup is based on a Proxmox cluster.

## Networks

### Network Devices on Proxmox

| Interface | VLAN ID | Description | IP Address     | Assigned To |
|-----------|---------|-------------|----------------|-------------|
| enp5s0    | -       | Management  | 192.168.0.2/24 | vmbr0       |
| enp42s0   | -       | VMs         | -              | vmbr1       |

### IP Ranges

| Bridge    | VLAN ID | Name    | CIDRv4         | CIDRv6         |
|-----------|---------|---------|----------------|----------------|
| vmbr1     | 10      | MGMT    | 10.10.0.0/24   | fd10::/64      |
| vmbr1     | 30      | PROD    | 10.30.0.0/24   | fd30::/64      |
| vmbr1     | 40      | SVC     | 10.40.0.0/24   | fd40::/64      |
| vmbr1     | 50      | STOR    | 10.50.0.0/24   | fd50::/64      |
| vmbr1     | 100     | DMZ     | 172.16.0.0/24  | fd64:100::/64  |

### Reserved IP Ranges

- 10.233.0.0/18: Kubernetes
- 10.233.64.0/18: Kubernetes
- 10.100.0.0/30: VPN

### Domains

- `server.home`: Main domain
- `prod.server.home`: Production domain
- `svc.server.home`: Service domain
- `s3.infra.server.home`: S3
- `bastion.infra.server.home`: Bastion
- `mgmt.infra.server.home`: Management
- `core.infra.server.home`: Core Services

## Repository Structure

The repository is structured as follows:

```bash
├── apps # Application configuration (e.g. HelmReleases)
│   ├── base
│   ├── core
│   └── production
│
├── clusters # Flux CI/CD configuration for each cluster
│   ├── core
│   └── production
│
├── infrastructure # Core infrastructure configuration (e.g. operators, service meshes, cert-manager)
│   ├── base
│   ├── core
│   └── production
│
└── namespaces
```
