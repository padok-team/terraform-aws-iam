variable "roles" {
  type        = map(object({
    assumePrincipal = string
    policies_name = list(string)
    }))
  description = "List of the roles to create"
}

variable "policies" {
  type = map(string)
  description = "List of the policies to create with format 'policy name' = 'policy'"
}

