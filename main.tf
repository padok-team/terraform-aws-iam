data "aws_caller_identity" "current" {}

# ---- ROLE ----

resource "aws_iam_role" "this" {
  count = var.role_name == null ? 0 : 1

  name        = var.role_name
  description = var.description == null ? var.role_name : var.description

  assume_role_policy = var.assume_role_policy
}

# ---- POLICY ----

resource "aws_iam_policy" "this" {
  count = var.policy == null ? 0 : 1

  name        = var.policy_name == null ? "${var.role_name}_policy" : var.policy_name
  path        = "/"
  description = var.policy_description == null ? (var.role_name == null ? var.policy_name : "A policy for role ${var.role_name}") : var.policy_description
  policy      = var.policy
}

# ---- ATTACHMENT ----

resource "aws_iam_role_policy_attachment" "this" {
  count = var.policy == null || var.role_name == null ? 0 : 1

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

## Attaching AWS Managed policies to role
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policies)

  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/${each.key}"
}
