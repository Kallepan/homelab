# Proxmox

## First steps

0. Change the root password:

    ```bash
    passwd
    ```

1. Delete the local-lvm storage:

    - Go to Datacenter -> Storage -> local-lvm -> Remove
    - Run the following commands:

        ```bash
        lvremove /dev/pve/data
        lvresize -l +100%FREE /dev/pve/root
        resize2fs /dev/pve/root

        reboot now
        ```

2. Configure apt:
    Taken from [here](https://pve.proxmox.com/wiki/Package_Repositories#_repositories_in_proxmox_ve)

    ```bash
    # Add the Proxmox VE repository
    echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list

    # Disable the enterprise repository
    sed -i '1s/^/# /' /etc/apt/sources.list.d/pve-enterprise.list
    sed -i '1s/^/# /' /etc/apt/sources.list.d/ceph.list
    ```

3. Configure Networking:
    - Go to Datacenter -> Network -> Enable Autostart on all network devices
    - Go to Datacenter -> Network -> Create a new bridge for VMs

4. Enable PCI passthrough:
    - Follow the documentation [here](https://pve.proxmox.com/wiki/PCI(e)_Passthrough) and view the documentation [here](https://pve.proxmox.com/wiki/PCI_Passthrough)

5. Setup cloud-init:
    - Download the latest ubuntu cloud image from [here](https://cloud-images.ubuntu.com)
    - Follow the documentation [here](https://pve.proxmox.com/wiki/Cloud-Init_Support)

6. Create ZFS pool:
    - Follow the documentation [here](https://pve.proxmox.com/wiki/ZFS_on_Linux)
    - Create a `tank` pool with a `backups` dataset
        - Disks -> ZFS -> Create ZFS
        - `mirror` the two disks
        - enable `lz4` compression
    - Datacenter -> Storage -> Remove `tank`
    - Mount `/tank/backups` as directory
