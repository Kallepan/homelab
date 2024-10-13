# Fetch imported Harvester cluster information.
data "rancher2_cluster_v2" "harvester-hci" {
  name = "harvester-hci"
}

# Cloud credentials
resource "rancher2_cloud_credential" "harvester-hci-cc" {
  name = "harvester-hci-cc"
  harvester_credential_config {
    cluster_id         = data.rancher2_cluster_v2.harvester-hci.cluster_v1_id
    cluster_type       = "imported"
    kubeconfig_content = data.rancher2_cluster_v2.harvester-hci.kube_config
  }
}

# Harvester configuration
resource "harvester_ssh_key" "homelab-ssh-key" {
  name       = "homelab-ssh-key"
  namespace  = "homelab"
  public_key = file("files/homelab.pub")
}


resource "harvester_image" "ubuntu-2404" {
  name      = "ubuntu-2404"
  namespace = "homelab"

  display_name = "ubuntu-2404"
  description  = "Ubuntu 24.04 LTS image"
  source_type  = "download"
  url          = "https://cloud-images.ubuntu.com/noble/20241004/noble-server-cloudimg-amd64.img"
}

resource "harvester_storageclass" "harvester-longhorn" {
  name           = "harvester-longhorn"
  is_default     = true
  reclaim_policy = "Delete"

  parameters = {
    "numberOfReplicas"    = "1"
    "migratable"          = "true"
    "staleReplicaTimeout" = "30"
  }
}

# Networking
data "harvester_clusternetwork" "mgmt" {
  name = "mgmt"
}

resource "harvester_network" "vms-network" {
  name      = "vms-network"
  namespace = "homelab"

  vlan_id = 0

  route_mode           = "auto"
  route_dhcp_server_ip = ""

  cluster_network_name = data.harvester_clusternetwork.mgmt.name
}
