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
    "adminS3" = {
      "assumePrincipal" : "{\"AWS\": \"arn:aws:iam::334033969502:role/lambda_writer\"}"
      "condition_operator" : var.condition_operator
      "condition_key" : var.condition_key
      "condition_value" : var.condition_value
      "condition_statement" : "{\"StringEquals\": {\"sts:ExternalId\": datadog_integration_aws.this.external_id }"
      "customPolicies" : ["s3_read_only"],
      "awsManagedPolicies" : ["AmazonS3FullAccess"]
    },
  }
}
