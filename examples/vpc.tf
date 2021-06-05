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
