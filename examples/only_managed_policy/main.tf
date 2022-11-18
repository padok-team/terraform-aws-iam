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

module "my_role" {
  source = "../../"

  name = "my_role"

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
}

output "role_arn" {
  value = module.my_role.this.arn
}
