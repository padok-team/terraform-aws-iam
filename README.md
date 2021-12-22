# AWS IAM Terraform module

Terraform module which creates **IAM** resources on **AWS**.

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
| <a name="input_roles"></a> [roles](#input\_roles) | List of the roles to create, for each role you must specify the assume principal, and the policies to bind to it (AWS Managed or custom policies) | <pre>map(object({<br>    assumePrincipal = string<br>    customPolicies = list(string)<br>    awsManagedPolicies = list(string)<br>    }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arns"></a> [role\_arns](#output\_role\_arns) | Arns of the roles created by the module, format is a map {'role\_name': 'role\_arn'} |
<!-- END_TF_DOCS -->
