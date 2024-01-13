# Setup CloudImage on Proxmox

A detailed guide can be found [here](https://pve.proxmox.com/wiki/Cloud-Init_Support)

## Ubuntu

### Download Image

```shell
# download the image
wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img

# create a new VM with VirtIO SCSI controller
qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci

# import the downloaded disk to the local-lvm storage, attaching it as a SCSI drive
qm set 9000 --scsi0 local-lvm:0,import-from=/path/to/bionic-server-cloudimg-amd64.img
```

- Do not forget to enable ssd emulation along with discard zeroes!!!

### Cloud init Image settings

```shell
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot order=scsi0
qm set 9000 --serial0 socket --vga serial0
qm template 9000
```

## Debian

- Download the latest image from [here](https://cloud.debian.org/images/cloud/bookworm/latest/)

```shell
wget https://cloud.debian.org/images/cloud/bullseye/20220613-1045/debian-11-genericcloud-amd64-20220613-1045.qcow2
```

```shell
qm create 9002 --name Debian11CloudInit --net0 virtio,bridge=vmbr0
qm importdisk 9002 debian-11-genericcloud-amd64-20220613-1045.qcow2 local-lvm
qm set 9002 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9002-disk-0
qm set 9002 --ide2 local-lvm:cloudinit
qm set 9002 --boot c --bootdisk scsi0
qm set 9002 --serial0 socket --vga serial0
qm set 9002 --agent enabled=1 #optional but recommended
qm template 9002
```

- Do not forget to enable ssd emulation along with discard zeroes
