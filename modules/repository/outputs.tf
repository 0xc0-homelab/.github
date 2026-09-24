output "ssh_clone_url" {
  description = "SSH clone URL."
  value       = github_repository.main.ssh_clone_url
}

output "repo_id" {
  description = "Numeric repository ID."
  value       = github_repository.main.repo_id
}
