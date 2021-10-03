output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_network_acl_id" {
  description = "The Network ACL ID of the VPC"
  value       = aws_vpc.main.default_network_acl_id
}

output "vpc_route_table_id" {
  description = "The Route Table ID of the VPC"
  value       = aws_vpc.main.default_route_table_id
}

output "vpc_security_group_id" {
  description = "The Security Group ID of the VPC"
  value       = aws_vpc.main.default_security_group_id
}

output "public_subnet_arn" {
  description = "The Public Subnet ARN of the VPC"
  value       = aws_subnet.main_public.*.arn
}

output "public_subnet_id" {
  description = "The Public Subnet ID of the VPC"
  value       = aws_subnet.main_public.*.id
}

output "public_subnet_cidr_block" {
  description =  "The Public Subnet CIDR block of the VPC"
  value       = aws_subnet.main_public.*.cidr_block
}

output "private_subnet_arn" {
  description =  "The Private Subnet ARN of the VPC"
  value       = aws_subnet.main_private.*.arn
}

output "private_subnet_id" {
  description =  "The Private Subnet ID of the VPC"
  value       = aws_subnet.main_private.*.id
}

output "private_subnet_cidr_block" {
  description =  "The Private Subnet CIDR block of the VPC"
  value       = aws_subnet.main_private.*.cidr_block
}

output "internet_gateway_id" {
  description =  "The Internet Gateway ID of the VPC"
  value       = aws_internet_gateway.main_internet_gateway.id
}

output "public_route_table_id" {
  description =  "The Public Route Table ID of the VPC"
  value       = aws_route_table.main_public_route_table.id
}

output "public_route_table" {
  description =  "The Public Route Table of the VPC"
  value       = aws_route_table.main_public_route_table.route
}

output "private_route_table_id" {
  description =  "The Private Route Table ID of the VPC"
  value       = aws_route_table.main_private_route_table.id
}

output "private_route_table" {
  description =  "The Private Route Table ID of the VPC"
  value       = aws_route_table.main_private_route_table.route
}