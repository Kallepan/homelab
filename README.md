# Homelab Setup GitOps Repository

This repository contains the configuration files for my homelab setup. The setup is based on a Proxmox cluster.

## Networks

### Network Devices on Proxmox

| Interface | VLAN ID | Description | IP Address     |
|-----------|---------|-------------|----------------|
| enp5s0    | -       | Management  | 192.168.0.2/24 |
| enp42s0   | -       | VMs         | -              |

### IP Ranges

| Interface | VLAN ID | Name    | CIDRv4         | CIDRv6         |
|-----------|---------|---------|----------------|----------------|
| vmbr1     | 10      | MGMT    | 10.10.0.0/24   | fd10::/64      |
| vmbr1     | 30      | PROD    | 10.30.0.0/24   | fd30::/64      |
| vmbr1     | 40      | STAG    | 10.40.0.0/24   | fd40::/64      |
| vmbr1     | 50      | STOR    | 10.50.0.0/24   | fd50::/64      |
| vmbr1     | 100     | DMZ     | 172.16.0.0/24  | fd64:100::/64  |

### Reserved IP Ranges

- 10.233.0.0/18: Kubernetes
- 10.233.64.0/18: Kubernetes
- 10.100.0.0/30: VPN

### Domains

- `server.home`: Main domain
- `prod.server.home`: Production domain
- `staging.server.home`: Staging domain
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
│   ├── production
│   └── test
├── clusters # Flux CI/CD configuration
│   ├── core
│   ├── production
│   └── test 
├── infrastructure # Core infrastructure configuration (e.g. operators, service meshes, cert-manager)
│   ├── base
│   ├── core
│   ├── production
│   └── test
└── namespaces
```
