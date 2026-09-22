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
