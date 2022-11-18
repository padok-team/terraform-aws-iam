variable "name" {
  description = "The role to create"
  type        = string
}

variable "description" {
  description = "A description for the role"
  type        = string
  default     = null
}

variable "managed_policies" {
  description = "List of the managed policies to attach to the role"
  type        = list(string)
  default     = []
}

variable "policy" {
  description = "The policy to create"
  type        = string
  default     = null
}

variable "policy_description" {
  description = "A description for the policy"
  type        = string
  default     = null
}

variable "assume_role_policy" {
  type = string
}
