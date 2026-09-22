# Applies from CI run in this GitHub Actions environment, and it waits for the
# operator's approval. That approval is the human launching the apply.
resource "github_repository_environment" "main" {
  repository  = module.repositories[".github"].name
  environment = "production"

  reviewers {
    users = [var.operator_user_id]
  }

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "main" {
  repository     = module.repositories[".github"].name
  environment    = github_repository_environment.main.environment
  branch_pattern = "main"
}
