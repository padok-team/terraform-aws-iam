terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Env         = local.env
      Region      = local.region
      OwnedBy     = "Padok"
      ManagedByTF = true
    }
  }
}

locals {

  name   = "basic"
  env    = "test"
  region = "eu-west-3"
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

module "my_role_with_oidc" {
  source = "../../"

  name = "my_role_with_oidc"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::334033969502:oidc-provider/oidc.eks.eu-west-3.amazonaws.com/id/79E03B22E2A81F0AE185390300FE5036"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.eu-west-3.amazonaws.com/id/79E03B22E2A81F0AE185390300FE5036:sub" : "system:serviceaccount:myservice:myservice"
          }
        }
      }
    ]
  })

  # Aws Managed Policies
  managed_policies = ["AmazonS3FullAccess"]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

output "role_arn" {
  value = module.my_role_with_oidc.this.arn
}
