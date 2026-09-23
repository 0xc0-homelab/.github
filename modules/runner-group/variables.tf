variable "name" {
  description = "Runner group name. Runners register into it by this name."
  type        = string
}

variable "workflows" {
  description = "The only workflows whose jobs may use the group, as org/repo/.github/workflows/file.yml@ref."
  type        = list(string)
}

variable "repository_ids" {
  description = "IDs of the only repositories whose workflows may use the group."
  type        = list(number)
}
