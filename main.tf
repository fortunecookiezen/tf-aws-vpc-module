resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      "Name"   = format("%s", var.name)
      "Region" = data.aws_region.current.name
    },
    var.tags,
    var.vpc_tags,
  )
}
# manage the default security group, no ingress or egress mean no rules
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this[0].id
  tags = {
    "Name" = "default"
  }
}

#manage the default network acl to detect drift
resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this[0].default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
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
