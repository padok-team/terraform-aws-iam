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
        "assumePrincipal" : "banane",
        "policies_name" : ["s3_read_only", "s3_admin"]
        },
        "hello" = {
        "assumePrincipal" : "lapin",
        "policies_name" : []
        }
    }
    policies = {
    "s3_read_only" = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowReadOnAllBucket",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectTagging",
                "s3:ListBucket",
                "s3:GetBucketAcl",
                "s3:ListBucketMultipartUploads",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
    "s3_admin" = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAllOnAllBucket",
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
  }
}
