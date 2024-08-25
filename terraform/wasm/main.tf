### Annotations ###

resource "kubernetes_annotations" "wasm-annotation" {
  api_version = "v1"
  kind        = "Node"

  metadata {
    name = "rke-wasm"
  }

  annotations = {
    "kwasm.sh/kwasm-node" = "true"
  }
}
