output "name" {
  description = "Repository name."
  value       = github_repository.this.name
}

output "full_name" {
  description = "owner/name."
  value       = github_repository.this.full_name
}

output "ssh_clone_url" {
  description = "SSH clone URL."
  value       = github_repository.this.ssh_clone_url
}
