variable "name" {
  description = "Runner group name. Runners register into it by this name."
  type        = string
}

variable "repository_ids" {
  description = "IDs of the only repositories whose workflows may use the group."
  type        = list(number)
}
