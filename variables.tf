variable "roles" {
  default = {}
  type        = map(object({
    assumePrincipal = string
    customPolicies = list(string)
    awsManagedPolicies = list(string)
    }))
  description = "List of the roles to create"
}

variable "policies" {
  default = {}
  type = map(string)
  description = "List of the policies to create with format 'policy name' = 'policy'"
}

