### Taints ###
resource "kubernetes_node_taint" "node1_noschedule_taint" {
  metadata {
    name = "node1"
  }

  taint {
    key    = "control-plane.kubernetes.io/NoSchedule"
    value  = "true"
    effect = "NoSchedule"
  }
}
resource "kubernetes_node_taint" "node2_noschedule_taint" {
  metadata {
    name = "node2"
  }

  taint {
    key    = "control-plane.kubernetes.io/NoSchedule"
    value  = "true"
    effect = "NoSchedule"
  }
}
resource "kubernetes_node_taint" "node3_noschedule_taint" {
  metadata {
    name = "node3"
  }

  taint {
    key    = "control-plane.kubernetes.io/NoSchedule"
    value  = "true"
    effect = "NoSchedule"
  }
}

### Labels ###
resource "kubernetes_labels" "node6-labels" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "node6"
  }

  labels = {
    "kubernetes.io/role"    = "worker"
    "kubernetes.io/storage" = "longhorn"
  }
}

resource "kubernetes_labels" "node7-labels" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "node7"
  }

  labels = {
    "kubernetes.io/role"    = "worker"
    "kubernetes.io/storage" = "longhorn"
  }
}

resource "kubernetes_labels" "node8-labels" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "node8"
  }

  labels = {
    "kubernetes.io/role"    = "worker"
    "kubernetes.io/storage" = "longhorn"
  }
}

resource "kubernetes_labels" "node9-labels" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "node9"
  }

  labels = {
    "kubernetes.io/role"    = "worker"
    "kubernetes.io/storage" = "longhorn"
  }
}