provider "rancher2" {
  api_url    = "${var.rancher_url}/v3"
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
}

# Obtain the Harvester cluster.
data "rancher2_cluster_v2" "hci" {
  name = var.harvester_cluster_name
}

# Obtain the Kubeconfig contents to pass to downstream clusters in order to use
# the Harvester cloud provider.
# See https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2#create-a-node-driver-cluster-with-harvester-as-both-the-infrastructure-provider-and-cloud-provider
data "http" "harvester_cloudprovider_kubeconfig_query" {
  url    = "${var.rancher_url}/k8s/clusters/${data.rancher2_cluster_v2.hci.cluster_v1_id}/v1/harvester/kubeconfig"
  method = "POST"

  request_headers = {
    Authorization = "Basic ${base64encode("${var.rancher2_access_key}:${var.rancher2_secret_key}")}"
    Content-Type  = "application/json"
  }

  request_body = <<EOF
    {
      "clusterRoleName": "harvesterhci.io:cloudprovider",
      "namespace": "${var.harvester_vm_namespace}",
      "serviceAccountName": "${var.harvester_cluster_name}"
    }
  EOF

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Invalid status code"
    }
  }
}

locals {
  # Format the response from the query.
  harvester_cloudprovider_kubeconfig_content = sensitive(trim(replace(data.http.harvester_cloudprovider_kubeconfig_query.response_body, "\\n", "\n"), "\""))
}

# Create a Cloud Credential for the Harvester cluster.
resource "rancher2_cloud_credential" "cloud_credential" {
  name = var.cluster_name
  harvester_credential_config {
    cluster_id         = data.rancher2_cluster_v2.hci.cluster_v1_id
    cluster_type       = "imported"
    kubeconfig_content = data.rancher2_cluster_v2.hci.kube_config
  }
}

# Create a machine configuration for the control plane pool using Harvester as
# infrastructure provider.
resource "rancher2_machine_config_v2" "control" {
  generate_name = "${var.cluster_name}-control"
  harvester_config {
    vm_namespace = var.harvester_vm_namespace
    cpu_count    = var.control_cpu
    memory_size  = var.control_ram
    ssh_user     = "ubuntu"

    disk_info = <<EOF
      {
        "disks": [{
          "imageName": "${var.vm_image}",
          "bootOrder": 1,
          "size": 40
        }]
      }
    EOF

    # Attach the control plane network.
    network_info = <<EOF
      {
        "interfaces": [{
          "networkName": "${var.network_name}"
        }]
      }
    EOF

    network_data = <<EOF
      network:
        version: 2
        ethernets:
          # Control plane network
          enp1s0:
            dhcp4: true
            %{if var.nameservers != null}nameservers: ${jsonencode({ addresses = var.nameservers })}%{endif}
    EOF

    user_data = <<EOF
      package_update: true
      packages:
        - qemu-guest-agent
      # Load the ip_vs kernel module on boot to support executing kube-proxy in
      # ipvs mode.
      runcmd:
        - - systemctl
          - enable
          - '--now'
          - qemu-guest-agent.service
        - - modprobe
          - ip_vs
      write_files:
        - path: /etc/modules-load.d/ipvs.conf
          owner: root:root
          permissions: '0644'
          defer: true
          content: |
            ip_vs
          encoding: text/plain
    EOF
  }
}

# Create a machine configuration for the worker pool using Harvester as
# infrastructure provider.
resource "rancher2_machine_config_v2" "worker" {
  generate_name = "${var.cluster_name}-worker"
  harvester_config {
    vm_namespace = var.harvester_vm_namespace
    cpu_count    = var.worker_cpu
    memory_size  = var.worker_ram
    ssh_user     = "ubuntu"

    disk_info = <<EOF
      {
        "disks": [{
          "imageName": "${var.vm_image}",
          "bootOrder": 1,
          "size": 40
        }]
      }
    EOF

    # Attach the control plane network and the load balancer network.
    # The order is important as it determines the network interface names
    # referenced in network_data.
    network_info = <<EOF
      {
        "interfaces":[
          {"networkName":"${var.network_name}"}
        ]
      }
    EOF

    network_data = <<EOF
      network:
        version: 2
        ethernets:
          # Control plane network
          enp1s0:
            dhcp4: true
            %{if var.nameservers != null}nameservers: ${jsonencode({ addresses = var.nameservers })}%{endif}
            %{if length(var.worker_routes) > 0}
            routes: ${jsonencode(var.worker_routes)}
            %{endif}
    EOF

    user_data = <<EOF
      package_update: true
      packages:
        - qemu-guest-agent
      # Load the ip_vs kernel module on boot to support executing kube-proxy in
      # ipvs mode.
      runcmd:
        - - systemctl
          - enable
          - '--now'
          - qemu-guest-agent.service
        - - modprobe
          - ip_vs
      write_files:
        - path: /etc/modules-load.d/ipvs.conf
          owner: root:root
          permissions: '0644'
          defer: true
          content: |
            ip_vs
          encoding: text/plain
    EOF
  }
}

# Create a machine configuration using Harvester as both infrastructure provider
# and cloud provider.
resource "rancher2_cluster_v2" "rke2_cluster" {
  name                         = var.cluster_name
  kubernetes_version           = var.cluster_kubernetes_version
  cloud_credential_secret_name = rancher2_cloud_credential.cloud_credential.id
  annotations = {
    "field.cattle.io/description" = "Terraform managed cluster"
    "ui.rancher/badge-color"      = var.rancher_badge_color
    "ui.rancher/badge-text"       = var.rancher_badge_text
    "ui.rancher/badge-icon-text"  = var.rancher_badge_icon_text
  }

  rke_config {
    # When using multiple network interfaces with calico, the IP autodetection
    # mechanism should be set to something other than firstFound.
    # Mode NodeInternalIP makes calico pick up the control plane subnet.
    chart_values = <<EOF
      harvester-cloud-provider:
        cloudConfigPath: /var/lib/rancher/rke2/etc/config-files/cloud-provider-config
        global:
          cattle:
            clusterName: ${var.cluster_name}
      rke2-calico:
        installation:
          calicoNetwork:
            nodeAddressAutodetectionV4:
              firstFound: false
              kubernetes: NodeInternalIP
    EOF

    # When using multiple network interfaces with calico, kube-proxy must run
    # in ipvs mode to route packets correctly. If MetalLB is installed in the
    # cluster, strict ARP mode is required, too.
    machine_global_config = <<EOF
      cni: calico
      disable-kube-proxy: false
      etcd-expose-metrics: false
      disable:
        - rke2-ingress-nginx
      kube-proxy-arg:
        - proxy-mode=ipvs
        - ipvs-strict-arp=true
    EOF

    machine_pools {
      name                = "control"
      control_plane_role  = true
      etcd_role           = true
      worker_role         = false
      drain_before_delete = true
      quantity            = var.control_nodes

      machine_config {
        kind = rancher2_machine_config_v2.control.kind
        name = rancher2_machine_config_v2.control.name
      }
    }

    machine_pools {
      name                = "worker"
      control_plane_role  = false
      etcd_role           = false
      worker_role         = true
      drain_before_delete = true
      quantity            = var.worker_nodes

      machine_config {
        kind = rancher2_machine_config_v2.worker.kind
        name = rancher2_machine_config_v2.worker.name
      }
    }

    machine_selector_config {
      config = yamlencode({
        cloud-provider-config   = local.harvester_cloudprovider_kubeconfig_content
        cloud-provider-name     = "harvester"
        protect-kernel-defaults = false
      })
    }

    upgrade_strategy {
      control_plane_concurrency = "1"
      worker_concurrency        = "1"

      control_plane_drain_options {
        enabled               = true
        delete_empty_dir_data = true
      }

      worker_drain_options {
        enabled               = true
        delete_empty_dir_data = true
      }
    }

    etcd {
      snapshot_retention     = 10
      snapshot_schedule_cron = "0 */20 * * *"

      dynamic "s3_config" {
        for_each = var.etcd_s3_access_key != null && var.etcd_s3_secret_key != null && var.etcd_s3_backup_bucket != null && var.etcd_s3_backup_endpoint != null ? [1] : []

        content {
          skip_ssl_verify       = true
          bucket                = var.etcd_s3_backup_bucket
          endpoint              = var.etcd_s3_backup_endpoint
          cloud_credential_name = rancher2_cloud_credential.s3_credentials[0].id
        }
      }
    }

  }
}


resource "rancher2_cloud_credential" "s3_credentials" {
  count = var.etcd_s3_access_key != null && var.etcd_s3_secret_key != null ? 1 : 0

  name = "${var.cluster_name}-s3-credentials"
  s3_credential_config {
    access_key = var.etcd_s3_access_key
    secret_key = var.etcd_s3_secret_key
  }
}
