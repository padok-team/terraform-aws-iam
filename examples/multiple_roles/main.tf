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

data "aws_caller_identity" "current" {}

module "my_role_1" {
  source = "../../"

  name = "my_role_1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com", "lambda.amazonaws.com"]
        }
      },
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

output "role_arn_1" {
  value = module.my_role_1.this.arn
}
module "my_role_2" {
  source = "../../"

  name = "my_role_2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com", "lambda.amazonaws.com"]
        }
      },
    ]
  })

  # Aws Managed Policies
  managed_policies = ["AmazonS3FullAccess"]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

output "role_arn_2" {
  value = module.my_role_2.this.arn
}
module "my_role_3" {
  source = "../../"

  name = "my_role_3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "AWS" : data.aws_caller_identity.current.account_id
        }
      },
    ]
  })

  # Aws Managed Policies
  managed_policies = []

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

output "role_arn_3" {
  value = module.my_role_3.this.arn
}

module "my_role_4" {
  source = "../../"

  name = "my_role_4"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "Federated" : "cognito-identity.amazonaws.com"
        }
      },
    ]
  })

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

output "role_arn_4" {
  value = module.my_role_4.this.arn
}
