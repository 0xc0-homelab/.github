# The deployments repo was renamed gitops: the same repository, renamed in place.
moved {
  from = module.repositories["deployments"]
  to   = module.repositories["gitops"]
}
