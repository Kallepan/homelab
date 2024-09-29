resource "gitlab_group_label" "bug" {
  name        = "bug"
  color       = "#FF0000"
  description = "Something isn't working"
  group       = "homelab"
}

resource "gitlab_group_label" "feature" {
  name        = "feature"
  color       = "#0000ff"
  description = "New feature or request"
  group       = "homelab"
}

resource "gitlab_group_label" "in_progress" {
  name        = "in progress"
  color       = "#FFA500"
  description = "Currently being worked on"
  group       = "homelab"
}
