provider "rancher2" {
  api_url    = var.rancher_url
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
  insecure   = true
}

provider "harvester" {
  kubeconfig = "files/harvester-hci.yaml"
}
