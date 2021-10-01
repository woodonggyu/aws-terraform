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
  description =  "The Network ACL ID of the VPC"
  value       = aws_vpc.main.default_network_acl_id
}

output "vpc_route_table_id" {
  description =  "The Route Table ID of the VPC"
  value       = aws_vpc.main.default_route_table_id
}

output "vpc_security_group_id" {
  description =  "The Security Group ID of the VPC"
  value       = aws_vpc.main.default_security_group_id
}