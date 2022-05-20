variable "name" {
  description = "The role to create"
  type        = string
}

variable "principal" {
  description = "The principal to assume"
  type        = string
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
