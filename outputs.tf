output "role" {
  description = "The role created by the module"
  value       = aws_iam_role.this
}

output "policy" {
  description = "The policy created by the module"
  value       = aws_iam_policy.this
}
