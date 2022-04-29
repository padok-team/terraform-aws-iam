variable "roles" {
  description = "List of the roles to create, for each role you must specify the assume principal, and the policies to bind to it (AWS Managed or custom policies)"
  type = map(object({
    assumePrincipal     = string
    condition           = string
    assume_condition    = string    
    customPolicies      = list(string)
    awsManagedPolicies  = list(string)
  }))
  default = {}
}

variable "policies" {
  description = "Map of the policies to create with format {'policy name' = 'policy'}"
  type        = map(string)
  default     = {}
}
