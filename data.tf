# we attempt to be fully region independent
data "aws_region" "current" {}
data "aws_availability_zones" "az" {
  state = "available"
}