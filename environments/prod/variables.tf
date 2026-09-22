variable "github_app_id" {
  description = "GitHub App ID used to manage the org. Comes from the environment, never from a tfvars file."
  type        = string
}

variable "github_app_installation_id" {
  description = "Installation ID of that App on the org. Comes from the environment."
  type        = string
}

variable "github_app_private_key" {
  description = "PEM contents of the App private key. Comes from the environment."
  type        = string
  sensitive   = true
}

variable "operator_user_id" {
  description = "GitHub user ID of the operator, who approves every apply."
  type        = number
}

# Deliberately set only on the command line (-var bootstrap=true), never in
# terraform.tfvars: committed, it would leave every ruleset disabled.
variable "bootstrap" {
  description = "True only for the first apply, before any history is pushed: rulesets are created disabled so main can receive its initial push."
  type        = bool
  default     = false
}

variable "repositories" {
  description = "Every repository in the org, keyed by name. Adding a repo is adding an entry here."
  type = map(object({
    description = string
    topics      = optional(list(string), [])
    # Applies from this repo's CI wait for the operator in a production environment.
    production_environment = optional(bool, false)
  }))

  validation {
    condition     = alltrue([for name in keys(var.repositories) : can(regex("^[A-Za-z0-9._-]{1,100}$", name))])
    error_message = "Repository names may only contain letters, digits, '.', '_' and '-', up to 100 characters."
  }

  validation {
    condition     = alltrue([for r in values(var.repositories) : length(trimspace(r.description)) > 0])
    error_message = "Every repository needs a non-empty description."
  }
}
