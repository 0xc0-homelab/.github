module "repositories" {
  source   = "../../modules/repository"
  for_each = var.repositories

  name                = each.key
  description         = each.value.description
  topics              = each.value.topics
  visibility          = "public"
  ruleset_enforcement = var.bootstrap ? "disabled" : "active"
}
