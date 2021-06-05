locals {
  max_subnet_length = max(
    length(var.private_subnets),
    length(var.isolated_subnets)
  )

  nat_gateway_count = var.enable_nat_gateway ? 0 : length(var.azs)

  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(
    concat(
      aws_vpc_ipv4_cidr_block_association.this.*.vpc_id,
      aws_vpc.this.*.id,
      [""],
    ),
    0,
  )
}

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      "Name"   = format("%s", var.name)
      "Region" = format("%s", data.aws_region.current.name)
    },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = var.create_vpc && length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  vpc_id = aws_vpc.this[0].id

  cidr_block = element(var.secondary_cidr_blocks, count.index)
}

# manage the default security group, no ingress or egress mean no rules
resource "aws_default_security_group" "this" {
  count = var.create_vpc ? 1 : 0

  vpc_id = aws_vpc.this[0].id
  tags = {
    "Name" = "default"
  }
}

#manage the default network acl to detect drift
resource "aws_default_network_acl" "this" {
  count = var.create_vpc ? 1 : 0

  default_network_acl_id = aws_vpc.this[0].default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.this[0].cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    "Name" = "default"
  }
}

#
# GATEWAYS
#

resource "aws_internet_gateway" "this" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.igw_tags,
  )
}

#
# ROUTES & ROUTE TABLES
#

# PUBLIC ROUTES
#
resource "aws_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = format("%s-${var.public_subnet_suffix}", var.name)
    },
    var.tags,
    var.public_route_table_tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

#
# PUBLIC SUBNETS
#
resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 && (length(var.public_subnets) <= length(data.aws_availability_zones.azs)) ? length(var.public_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = element(concat(var.public_subnets, [""]), count.index)
  availability_zone               = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  assign_ipv6_address_on_creation = false

  tags = merge(
    {
      "Name" = format(
        "%s-${var.public_subnet_suffix}-%s",
        var.name,
        data.aws_availability_zones.azs.names[count.index]
      )
    },
    var.tags,
    var.public_subnet_tags,
  )
}

#
# PRIVATE SUBNETS
#

resource "aws_subnet" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 && (length(var.private_subnets) <= length(data.aws_availability_zones.azs)) ? length(var.private_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = var.private_subnets[count.index]
  availability_zone               = data.aws_availability_zones.azs.names[count.index]
  assign_ipv6_address_on_creation = false

  tags = merge(
    {
      "Name" = format(
        "%s-${var.private_subnet_suffix}-%s",
        var.name,
        data.aws_availability_zones.azs.names[count.index]
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

#
# ISOLATED SUBNETS
#

resource "aws_subnet" "isolated" {
  count = var.create_vpc && length(var.isolated_subnets) > 0 && (length(var.isolated_subnets) <= length(data.aws_availability_zones.azs)) ? length(var.isolated_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = var.isolated_subnets[count.index]
  availability_zone               = data.aws_availability_zones.azs.names[count.index]
  assign_ipv6_address_on_creation = false

  tags = merge(
    {
      "Name" = format(
        "%s-${var.isolated_subnet_suffix}-%s",
        var.name,
        data.aws_availability_zones.azs.names[count.index]
      )
    },
    var.tags,
    var.isolated_subnet_tags,
  )
}
