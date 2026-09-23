module "repositories" {
  source   = "../../modules/repository"
  for_each = var.repositories

  name                = each.key
  description         = each.value.description
  topics              = each.value.topics
  visibility          = "public"
  ruleset_enforcement = var.bootstrap ? "disabled" : "active"

  production_environment_reviewers = each.value.production_environment ? [var.operator_user_id] : []
}

# The self-hosted runners on vm-ci (infrastructure#44).
module "runner_group" {
  source = "../../modules/runner-group"

  name           = var.runner_group.name
  repository_ids = [for repo in var.runner_group.repositories : module.repositories[repo].repo_id]
}
