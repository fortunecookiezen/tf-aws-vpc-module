# tf-aws-vpc-module

Mostly as a test for ci/cd, terraform cloud, and sentinel development.

Please use the official [aws vpc terraform module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) instead.

## module principles

* Inherit your configuragion from your environment: this module uses terraform data structures to determine the number of availability zones of the region it is in. As long as you keep `length(var.subnets) <= length(data.aws_availability_zones.azs)` it can deploy in any region.

* DRY: Don't Repeat Yourself, at least as much as you can because Terraform isn't an actual programming language

## implementation details

* NACLs are pretty wide open: public and private subnets have permissive nacls, isolated subnets do not.

* Security groups are not a part of this. They belong with the member resources. When I get around to adding endpoint support, the endpoint security group will be a part of this module, see reason.

## usage

See `./examples/`

``` shell
module "vpc" {
  source = "../"
  name   = "test"
  cidr   = "10.10.0.0/20"

  create_igw = true

  public_subnets   = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnets  = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24", "10.10.7.0/24"]
  isolated_subnets = ["10.10.8.0/24", "10.10.9.0/24", "10.10.10.0/24", "10.10.11.0/24"]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    PCI = "false"
  }
}

```
