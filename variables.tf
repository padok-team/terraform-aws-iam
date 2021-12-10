variable "roles" {
  type        = list(object({
    role_name = string
    assumePrincipal = string
    policies_name = list(string)
    }))
  description = "List of the roles to create"
}

variable "policies" {
  type = list(object({
    name = string
    policy = string
  }))
  description = "List of the policies to create"
}

