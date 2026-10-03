# deployments was renamed gitops in place.
moved {
  from = module.repositories["deployments"]
  to   = module.repositories["gitops"]
}
