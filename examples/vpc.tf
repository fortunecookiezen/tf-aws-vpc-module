module "vpc" {
  source = "../"
  name   = "vpc"
  cidr   = "10.10.0.0/20"

  create_igw = false

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-name"
  }
}
