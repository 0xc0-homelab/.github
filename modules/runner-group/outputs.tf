output "name" {
  description = "Runner group name."
  value       = github_actions_runner_group.main.name
}

output "id" {
  description = "Runner group ID."
  value       = github_actions_runner_group.main.id
}
