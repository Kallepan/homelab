# Cluster Setup: Kubernetes 1.27 on Ubuntu 22.04

## Upgrade Machines

```bash
sudo apt update
sudo apt -y full-upgrade
[ -f /var/run/reboot-required ] && sudo reboot -f
```

## Install Kubernetes Software

```bash
# Prerequisites
sudo apt install curl apt-transport-https -y
curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/k8s.gpg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install
sudo apt update
sudo apt install wget curl vim git kubelet kubeadm kubectl -y
sudo apt-mark hold kubelet kubeadm kubectl

# Confirm
kubectl version --client && kubeadm version
```

## Disable SWAP

```bash
sudo swapoff -a 

# And check
free -h
```

## Install Container runtime (Master and Worker nodes)

```bash
# Configure persistent loading of modules
sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

# Load at runtime
sudo modprobe overlay
sudo modprobe br_netfilter

# Ensure sysctl params are set
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload configs
sudo sysctl --system

# Install required packages
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Add Docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install containerd
sudo apt update
sudo apt install -y containerd.io

# Configure containerd and start service
sudo su -
mkdir -p /etc/containerd
containerd config default>/etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
systemctl status containerd
```

- To use the systemd cgroup driver, set plugins.cri.systemd_cgroup = true in /etc/containerd/config.toml.
- When using kubeadm, manually configure the cgroup driver for kubelet

## Initialize Control Plane

```bash
# Check if modprobes are active
lsmod | grep br_netfilter

# Enable kubelet
sudo systemctl enable kubelet

# Pull images
sudo kubeadm config images pull

# Initialize Control Plane
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16
```

### To Export kubeconfig

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## Additional Setup

### Get Join command

```bash
kubeadm token create --print-join-command
```

### Install Calico

- Follow this [guide](https://docs.tigera.io/calico/latest/getting-started/kubernetes/helm).

### Install Helm

```bash
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

## Profit
