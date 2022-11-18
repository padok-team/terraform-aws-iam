data "aws_caller_identity" "current" {}

resource "aws_iam_role" "this" {
  name        = var.name
  description = var.description == null ? var.name : var.description

  assume_role_policy = templatefile("${path.module}/assume_policy.tpl", { principals = var.principal })
}

resource "aws_iam_policy" "this" {
  count = var.policy == null ? 0 : 1

  name        = "${var.name}_policy"
  path        = "/"
  description = var.policy_description == null ? "A policy for role ${var.name}" : var.policy_description
  policy      = var.policy
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.policy == null ? 0 : 1

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this[0].arn
}

## Attaching AWS Managed policies to role
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policies)

  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/${each.key}"
}
