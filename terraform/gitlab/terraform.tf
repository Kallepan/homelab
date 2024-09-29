terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
    }
  }
}

provider "gitlab" {
  # Configuration options
  base_url = "https://gitlab.srv-lab.server.home"
  token    = var.gitlab_token
  insecure = true
}
