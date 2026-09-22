output "repositories" {
  description = "SSH clone URL of every managed repository."
  value       = { for k, r in module.repositories : k => r.ssh_clone_url }
}
