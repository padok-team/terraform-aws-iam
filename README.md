# AWS IAM Terraform module

Terraform module which creates **IAM** resources (roles and policies) on **AWS**.

## User Stories for this module

- AAOps I can create a role with a custom policy and managed policies
- AAOps I can create a role only with a managed AWS IAM policy
- AAOps I can create a policy only

## Usage

```hcl
module "my_role" {
  source = "../../"

  role_name = "my_role"

  principal = jsonencode({
      "Service": ["ec2.amazonaws.com", "lambda.amazonaws.com" ]
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
  value = module.my_role.role[0].arn
}
```

```hcl
module "my_policy" {
  source = "../../"

  policy_name = "my_policy"

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

output "policy_arn" {
  value = module.my_policy.policy[0].arn
}
```

## Examples

- [I can create a policy only](examples/basic-with-policy-only/main.tf)
- [I can create a role and attach existing policies (AWS managed or not) to it](examples/basic-with-role/main.tf)
- [I can create many roles with custom policies and different principales](examples/multiple_roles/main.tf)
- [I can create a role with only a managed policies](examples/only_managed_policy/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | n/a | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the role | `string` | `null` | no |
| <a name="input_managed_policies"></a> [managed\_policies](#input\_managed\_policies) | List of the managed policies to attach to the role | `list(string)` | `[]` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy to create | `string` | `null` | no |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | A description for the policy | `string` | `null` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | The role to create | `string` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The role to create | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy"></a> [policy](#output\_policy) | The policy created by the module |
| <a name="output_role"></a> [role](#output\_role) | The role created by the module |
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
