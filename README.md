# Homelab Setup

This repository contains the configuration files for my homelab setup. The setup is based on a Proxmox hypervisor running on consumer hardware. The hypervisor runs a number of virtual machines and containers, which are managed using Ansible and terraform.

## Networks

### Network Devices

| Interface | VLAN ID | Description | IP Address     |
|-----------|---------|-------------|----------------|
| enp5s0    | -       | Management  | 192.168.0.2/24 |
| enp42s0   | -       | VMs         | -              |

### IP Ranges

| Interface | VLAN ID | Name    | CIDRv4        | CIDRv6          |
|-----------|---------|---------|---------------|-----------------|
| vmbr1     | 10      | LAN1    | 10.0.0.0/16   | fd00:0:0:1::/64 |
| vmbr1     | 20      | LAN2    | 10.1.0.0/16   | fd00:0:0:2::/64 |
| vmbr1     | 100     | DMZ     | 172.16.1.0/24 | fd00::/64       |

### Reserved IP Ranges

- 10.233.0.0/18: Kubernetes
- 10.233.64.0/18: Kubernetes
- 10.100.0.0/24: VPN
