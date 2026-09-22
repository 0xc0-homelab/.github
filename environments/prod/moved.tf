# The production environment moved from this root into the repository module.
# These blocks move it in the state instead of destroying and recreating it.
moved {
  from = github_repository_environment.main
  to   = module.repositories[".github"].github_repository_environment.main[0]
}

moved {
  from = github_repository_environment_deployment_policy.main
  to   = module.repositories[".github"].github_repository_environment_deployment_policy.main[0]
}
