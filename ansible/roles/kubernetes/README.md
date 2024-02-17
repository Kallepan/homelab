# kubernetes role

## Overview

This role prepres master and worker nodes for Kubernetes installation. It installs the necessary packages, configures the necessary kernel parameters, and sets up the necessary directories and systemd units as well as preparing the repository for Kubernetes installation.

## Procedure

- Run the ansible-playbook command to apply the kubernetes role to the hosts in the k8s-master and k8s-worker groups.

```bash
cd ansible
ansible-playbook kubernetes.yaml
```

- Run kubeadm init on the master node to initialize the Kubernetes control plane.

```bash
ssh k8s-master-1

# Adjust the values of KUBE_VIP_IP and POD_CIDR as needed.
export KUBE_VIP_IP=10.0.255.0
export POD_CIDR=10.244.0.0/16

sudo kubeadm init --control-plane-endpoint "$KUBE_VIP_IP:6443" --upload-certs --pod-network-cidr="$POD_CIDR"

#
# !!!cp /etc/kubernetes/kube-vip.yaml to all other master nodes!!!
#

# Note the output of the kubeadm init command, which includes the kubeadm join command to add worker nodes to the cluster.
```

## Tasks

### Preflight

[file](tasks/preflight.yaml)

- **Create /etc/apt/keyrings directory**: This task creates the /etc/apt/keyrings directory, which is used to store GPG keys for APT repositories.

- **Ensure containerd config directory exists**: This task ensures that the /etc/containerd directory exists, which is used to store containerd configuration files.

### Swapoff

[file](tasks/swapoff.yaml)

- **Check if /etc/fstab exists**: This task checks if the /etc/fstab file exists on the host. The /etc/fstab file is used to define how disk partitions, various other block devices, or remote filesystems should be mounted into the filesystem. The result of this check is registered in the fstab_file variable.

- **Remove swapfile from /etc/fstab**: This task removes any swap entries from the /etc/fstab file. This ensures that swap is not enabled on subsequent reboots. This task only runs if the /etc/fstab file exists.

- **Mask swap.target (persist swapoff)**: This task masks the swap.target service in systemd. Masking a service prevents it from being started, manually or automatically. This ensures that swap remains off even if something tries to enable it.

- **Disable swap**: This task runs the swapoff -a command to disable swap immediately. The -a option causes all devices marked as swap in /etc/fstab to be disabled.

### Update

[file](tasks/update.yaml)

- **Update all packages**: This task runs the apt update command to update the package lists for upgrades and new packages. It then runs the apt upgrade command to upgrade all installed packages to their latest versions.

### Kernel Modules

[file](tasks/kernel_modules.yaml)

- **Create the modules-load.d directory**: This task creates the `/etc/modules-load.d` directory if it doesn't exist. This directory is used to store configuration files for kernel modules to be loaded at boot time.

- **Set the kernel modules to be loaded on boot**: This task creates a configuration file at `/etc/modules-load.d/containerd.conf` and writes the names of the kernel modules to be loaded at boot time. The names of the kernel modules are provided by the `kubernetes_kernel_modules` variable.

- **Load the kernel modules**: This task uses the `modprobe` command to load the specified kernel modules immediately. The names of the kernel modules are provided by the `kubernetes_kernel_modules` variable.

- **Create the sysctl.d directory**: This task creates the `/etc/sysctl.d` directory if it doesn't exist. This directory is used to store system configuration files for the `sysctl` command.

- **Enable sysctl settings**: This task creates a configuration file at `/etc/sysctl.d/99-kubernetes-cri.conf` and writes the specified sysctl settings. The sysctl settings are provided by the `kubernetes_kernel_sysctl` variable. After this task is completed, the `apply sysctl settings` handler is notified.

- **Note**: The `apply sysctl settings` handler is not defined in this playbook. It should be defined elsewhere in your Ansible project, and it should apply the sysctl settings by running the `sysctl --system` command or similar.

### Packages

[file](tasks/packages.yaml)

- **Install kubernetes packages**: This task installs the necessary packages for Kubernetes using the apt module. The packages to be installed are specified by the `kubernetes_packages` variable.

### Containerd

[file](tasks/containerd.yaml)

- **Download docker gpg key**: This task downloads the GPG key for Docker's Ubuntu repository and saves it to /etc/apt/keyrings/docker.asc. The GPG key is used to verify the integrity of the packages downloaded from the repository.

- **Set permissions on docker gpg key**: This task sets the permissions of the GPG key file to 0644, ensuring that it can be read by all users.

- **Delete old docker repository file**: This task deletes the old Docker repository file at /etc/apt/sources.list.d/docker.list, if it exists.

- **Add the containerd repository**: This task adds Docker's Ubuntu repository to the system's list of APT sources. It specifies that the repository's packages are signed with the GPG key downloaded earlier.

- **Install containerd**: This task installs the containerd.io package from the Docker repository.

- **Parse containerd file to config dir**: This task generates a default configuration file for containerd and saves it to /etc/containerd/config.toml.

- **Replace SystemdCGroup in containerd config**: This task modifies the containerd configuration file to enable the use of systemd for cgroup management. This is done by replacing the line SystemdCgroup = false with SystemdCgroup = true.

- **Restart containerd**: This task restarts the containerd service to apply the changes made to its configuration file.

- **Ensure containerd is started on boot**: This task enables the containerd service to start on boot, ensuring that it is always running when the system is up.

### Kubernetes

[file](tasks/kubernetes.yaml)

- **Delete old Kubernetes GPG key**: This task deletes the old GPG key for Kubernetes' Ubuntu repository if it exists.

- **Download Kubernetes GPG key**: This task downloads the GPG key for Kubernetes' Ubuntu repository and saves it to a temporary file. The GPG key is used to verify the integrity of the packages downloaded from the repository.

- **Install Kubernetes GPG key**: This task installs the downloaded GPG key into the APT keyring. This allows APT to trust packages signed with this key.

- **Delete old Kubernetes repository file**: This task deletes the old Kubernetes repository file if it exists. This ensures that the old repository is not used for package installations.

- **Add new Kubernetes apt repository**: This task adds the new Kubernetes repository to the system's list of APT sources. It also updates the APT package cache to include packages from the new repository.

- **Install kubeadm, kubelet and kubectl**: This task installs the kubeadm, kubelet, and kubectl packages from the Kubernetes repository. kubeadm is a tool for bootstrapping a Kubernetes cluster. kubelet is the most fundamental building block of a Kubernetes cluster, responsible for managing pods and their containers on a node. kubectl is a command-line tool for interacting with a Kubernetes cluster.

- **Hold kubeadm, kubelet and kubectl**: This task marks the kubeadm, kubelet, and kubectl packages as held back, which means they will not be automatically upgraded when you run apt upgrade. This is useful when you want to control the versions of these packages manually.

### Generate kube-vip manifest

[file](tasks/generate_manifest.yaml)

- **Task: Generate the kube-vip manifest**: This task pulls the kube-vip image from the GitHub Container Registry and runs it with several options. The output of this command, which is the kube-vip manifest, is registered in the kube_vip_manifest variable. This task only runs on the host named "k8s-master-1".

ctr image pull ghcr.io/kube-vip/kube-vip:{{ kvversion }}: This command pulls the kube-vip image of the version specified by the kvversion variable.
ctr run --rm --net-host ghcr.io/kube-vip/kube-vip:{{ kvversion }} vip /kube-vip manifest pod: This command runs the kube-vip image, removing the container after it exits and using the host network.
--interface {{ interface }}: This option specifies the network interface to bind to.
--address {{ vip }}: This option specifies the virtual IP address.
--controlplane: This option enables control plane functionality.
--services: This option enables service load balancing.
--arp: This option enables ARP for virtual IP address advertisement.
--leaderElection: This option enables leader election to ensure only one instance is operating.

- **Task: Write kube-vip manifest**: This task writes the kube-vip manifest generated by the previous task to a file at /etc/kubernetes/manifests/kube-vip.yaml. This task only runs on the host named "k8s-master-1".

content: "{{ kube_vip_manifest.stdout }}": This specifies the content to be written to the file, which is the output of the previous task.
dest: /etc/kubernetes/manifests/kube-vip.yaml: This specifies the destination path of the file to be written.
Both tasks are tagged with "kubernetes" and "kube-vip", which can be used to run these tasks specifically when using the ansible-playbook command with the --tags option.
