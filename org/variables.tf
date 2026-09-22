variable "github_app_id" {
  description = "GitHub App ID used to manage the org."
  type        = string
}

variable "github_app_installation_id" {
  description = "Installation ID of that App on the org."
  type        = string
}

variable "github_app_private_key" {
  description = "PEM contents of the App private key."
  type        = string
  sensitive   = true
}

variable "bootstrap" {
  description = "True only for the first apply, before any history is pushed: rulesets are created disabled so main can receive its initial push."
  type        = bool
  default     = false
}

variable "operator_user_id" {
  description = "GitHub user ID of the operator, who approves every apply."
  type        = number
  default     = 94703619 # sergioaten
}
