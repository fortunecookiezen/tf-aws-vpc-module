# tf-aws-vpc-module

Mostly as a test for ci/cd, terraform cloud, and sentinel development.

Please use the official [aws vpc terraform module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) instead.

## usage

See examples

``` shell
module "vpc" {
  source = "github.com/fortunecookiezen/tf-aws-vpc-module"
  name   = "vpc"
  cidr   = "10.10.0.0/20"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-name"
  }
}
```
