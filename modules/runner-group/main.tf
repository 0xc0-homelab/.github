resource "github_actions_runner_group" "main" {
  name       = var.name
  visibility = "selected"

  selected_repository_ids = var.repository_ids

  # The org's repos are public. The group admits them, and the workflows keep
  # fork PRs off the self-hosted runners.
  allows_public_repositories = true
}
