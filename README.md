# AWS IAM Terraform module

Terraform module which creates **IAM** resources (roles and policies) on **AWS**.

## User Stories for this module

- AAOps I can create a role with a custom policy and managed policies
- AAOps I can create a role only with a managed AWS IAM policy

## Usage

```hcl
module "my_role" {
  source = "../../"

    name = "my_role"

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
  value = module.my_role.this.arn
}
```

## Examples

- [I can create a role and attach existing policies (AWS managed or not) to it](examples/basic/main.tf)
- [I can create many roles with custom policies and different principales](examples/multiple_roles/main.tf)
- [I can create a role with only a managed policies](examples/only_managed_policy/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The role to create | `string` | n/a | yes |
| <a name="input_principal"></a> [principal](#input\_principal) | The principal to assume | `string` | n/a | yes |
| <a name="input_managed_policies"></a> [managed\_policies](#input\_managed\_policies) | List of the managed policies to attach to the role | `list(string)` | `[]` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy to create | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this"></a> [this](#output\_this) | The role created by the module |
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
