data "aws_caller_identity" "current" {}

resource "aws_iam_role" "this" {
    for_each = var.roles
    name = each.key
    assume_role_policy = templatefile("${path.module}/assume_policy.tpl", {principalsRole = each.value["assumePrincipal"]})
}

resource "aws_iam_policy" "this" {
    for_each = var.policies

    name = each.key
    policy = each.value
}

locals { 
  mapping_policies_roles = flatten([
    for role, role_elements in var.roles : [
      for policy in role_elements["customPolicies"] : {
        role   = role
        policy = policy
      }
    ]
  ])
}

## Attaching policies to role
resource "aws_iam_role_policy_attachment" "custom" {
  for_each = { for attachment in local.mapping_policies_roles:  
    "${attachment["role"]}_${attachment["policy"]}" => {"role": attachment["role"], "policy": attachment["policy"]}
    }


  role       = each.value["role"]
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${each.value["policy"]}"

  depends_on = [aws_iam_role.this]
}

locals { 
  mapping_aws_policies_roles = flatten([
    for role, role_elements in var.roles : [
      for policy in role_elements["awsManagedPolicies"] : {
        role   = role
        policy = policy
      }
    ]
  ])
}

## Attaching AWS Managed policies to role
resource "aws_iam_role_policy_attachment" "aws_managed" {
  for_each = { for attachment in local.mapping_aws_policies_roles:  
    "${attachment["role"]}_${attachment["policy"]}" => {"role": attachment["role"], "policy": attachment["policy"]}
    }


  role       = each.value["role"]
  policy_arn = "arn:aws:iam::policy/${each.value["policy"]}"

  depends_on = [aws_iam_role.this]
}
