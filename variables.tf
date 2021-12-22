variable "roles" {
  default = {}
  type = map(object({
    assumePrincipal    = string
    customPolicies     = list(string)
    awsManagedPolicies = list(string)
  }))
  description = "List of the roles to create, for each role you must specify the assume principal, and the policies to bind to it (AWS Managed or custom policies)"
}

variable "policies" {
  default     = {}
  type        = map(string)
  description = "Map of the policies to create with format {'policy name' = 'policy'}"
}

