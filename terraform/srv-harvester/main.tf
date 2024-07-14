resource "harvester_cloudinit_secret" "cloud-config-default" {
  name      = "cloud-config-default"
  namespace = "default"

  user_data = <<-EOF
    #cloud-config
    users:
      - name: ubuntu
        passwd: ${var.ubuntu_password}
        lock_passwd: true
        sudo: ALL=(ALL) NOPASSWD:ALL
        chpasswd:
          expire: False
        ssh_authorized_keys:
          -  ${var.ssh_key}
    package_update: true
    package_upgrade: true
    packages:
      - qemu-guest-agent
    runcmd:
      - - systemctl
        - enable
        - --now
        - qemu-guest-agent.service
  EOF

  network_data = <<-EOF
    networks:
      version: 2
      ethernets:
        eth0:
          dhcp4: true
  EOF

  description = "Default cloud-config for Harvester VMs"
}

resource "harvester_ssh_key" "homelab_key" {
  name      = "homelab_key"
  namespace = "default"

  public_key = var.ssh_key
}

resource "harvester_storageclass" "default-sc" {
  name = "default-sc"

  parameters = {
    "migratable"          = "true"
    "numberOfReplicas"    = "1"
    "staleReplicaTimeout" = "30"
  }

  reclaim_policy = "Delete"
  is_default     = true

}

resource "harvester_image" "ubuntu-24.04" {
  name      = "ubuntu-24.04"
  namespace = "images"

  display_name = "ubuntu-24.04-server-cloudimg-amd64.img"
  source_type  = "download"
  url          = var.ubuntu_image_url

}
