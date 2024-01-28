# Cluster 1

## Description

Cluster 1 was provisioned using kubespray. Copy the hosts.yaml file along with the changed configs from [here](./inventory) to the inventory folder of kubespray.

## Usage

The following excerpt was adapted from [here](https://kubespray.io/#/)

```bash
# Copy ``inventory/sample`` as ``inventory/cluster-1``
cp -rfp inventory/sample inventory/cluster-1

# Update Ansible inventory file with inventory builder
declare -a IPS=(10.0.3.1 10.0.3.2 10.0.3.3 10.0.3.4 10.0.3.5)
CONFIG_FILE=inventory/cluster-1/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Review and change parameters under ``inventory/cluster-1/group_vars``
cat inventory/cluster-1/group_vars/all/all.yml
cat inventory/cluster-1/group_vars/k8s_cluster/k8s-cluster.yml

# Clean up old Kubernetes cluster with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example cleaning up SSL keys in /etc/,
# uninstalling old packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
# And be mind it will remove the current kubernetes cluster (if it's running)!
ansible-playbook -i inventory/cluster-1/hosts.yaml  --become --become-user=root reset.yml

# Deploy Kubespray with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example writing SSL keys in /etc/,
# installing packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
ansible-playbook -i inventory/cluster-1/hosts.yaml  --become --become-user=root cluster.yml
```
