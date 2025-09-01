output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this[0].id
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this[0].cidr_block
}
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}
output "isolated_subnet_ids" {
  description = "List of isolated subnet IDs"
  value       = aws_subnet.isolated[*].id
}
output "transit_gateway_subnet_ids" {
  description = "List of Transit Gateway Subnet IDs"
  value       = aws_subnet.transit_gateway[*].id
}
output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}
output "route_table_ids" {
  description = "List of Route Table IDs"
  value       = aws_route_table.this[*].id
}
output "security_group_ids" {
  description = "List of Security Group IDs"
  value       = aws_security_group.this[*].id
}