module "vpc" {
  source = "../"
  name   = "test"
  cidr   = "10.10.0.0/20"

  create_igw = true

  public_subnets   = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnets  = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24", "10.10.7.0/24"]
  isolated_subnets = ["10.10.8.0/24", "10.10.9.0/24", "10.10.10.0/24", "10.10.11.0/24"]

  private_route_table_routes = [
    {
      "cidr_block" : "10.0.0.0/8",
      "transit_gateway_id" : "tgw-005ea974aa5468d79"
    },
    {
      "destination_prefix_list_id" : "pl-63a5400a",
      "transit_gateway_id" : "tgw-005ea974aa5468d79"
    }
  ]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    PCI = "false"
  }
}
