# AWS IAM Terraform module

Terraform module which creates **IAM** resources (roles and policies) on **AWS**.

## User Stories for this module

- AAOps I can create roles and attach existing policies to them
- AAOps I can create roles and attach new policies to them

## Usage

```hcl
module "iam" {
    source = "../../"
    roles = {
        "ec2_reader" = {
            "assumePrincipal" : "{\"Service\": \"ec2.amazonaws.com\"}",
            "customPolicies" : ["s3_read_only"],
            "awsManagedPolicies" : []
        },
        "lambda_writer" = {
            "assumePrincipal" : "{\"Service\": \"lambda.amazonaws.com\"}",
            "customPolicies" : ["s3_admin"],
            "awsManagedPolicies" : []
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
```

## Examples

- [I can create a role and attach existing policies (AWS managed or not) to it](examples/1_role_aws_and_existing_policies/main.tf)
- [I can create 2 roles and 2 policies and attach one policy to each role](examples/2_roles_2_bucket_policies/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_policies"></a> [policies](#input\_policies) | Map of the policies to create with format {'policy name' = 'policy'} | `map(string)` | `{}` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | List of the roles to create, for each role you must specify the assume principal, and the policies to bind to it (AWS Managed or custom policies) | <pre>map(object({<br>    assumePrincipal    = string<br>    customPolicies     = list(string)<br>    awsManagedPolicies = list(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_roles"></a> [iam\_roles](#output\_iam\_roles) | Arns of the roles created by the module, format is a map {'role\_name': 'role\_arn'} |
<!-- END_TF_DOCS -->

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```
