# Here you can reference 2 type of terraform objects :
# 1. Ressources from you provider of choice
# 2. Modules from official repositories which include modules from the following github organizations
#     - AWS: https://github.com/terraform-aws-modules
#     - GCP: https://github.com/terraform-google-modules
#     - Azure: https://github.com/Azure

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "this" {
    for_each = toset(var.roles)
    name = each.value["name"]
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = each.value["assumePrincipal"]
      },
    ]
     })
}

resource "aws_iam_policy" "this" {
    for_each = toset(var.policies)

    name = each.value["name"]
    policy = each.value["policy"]
}

locals {
  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  mapping_policies_roles = flatten([
    for role, role_elements in toset(var.roles) : [
      for policy in role_elements["policies_name"] : {
        role   = role_elements["role_name"]
        policy = policy
      }
    ]
  ])
}

### Attaching policies to role
resource "aws_iam_role_policy_attachment" "this" {
  count      = length(local.mapping_policies_roles)

  role       = local.mapping_policies_roles[count.index]["role"]
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.mapping_policies_roles[count.index]["policy"]}"

  depends_on = [aws_iam_role.this]
}


