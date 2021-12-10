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
        "assumePrincipal" : "root",
        "customPolicies" : ["existingPolicy"],
        "awsManagedPolicies": ["AmazonS3FullAccess"]
        },
    }
}
