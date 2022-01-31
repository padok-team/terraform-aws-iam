output "iam_roles" {
  description = "Arns of the roles created by the module, format is a map {'role_name': 'role_arn'}"
  value       = { for role_key, role in aws_iam_role.this : role_key => role.arn }
}
