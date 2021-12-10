provider "aws" {
  region = "eu-west-3"

  default_tags {
    tags = {
      ManagedByTF = true
    }
  }
}

module "iam" {
  source = "../../"
  roles = {
    "bonjour" = {
      "assumePrincipal" = "banane",
      "customPolicies" = ["s3_full_access_test", "s4_full_access_test"],
      "awsManagedPolicies" = ["AdministratorAccess"]
    },
    "hello" = {
      "assumePrincipal" = "lapin",
      "customPolicies" = [],
      "awsManagedPolicies" = []
    }
  }

  policies = {
    "s3_full_access_test" = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  }
}

