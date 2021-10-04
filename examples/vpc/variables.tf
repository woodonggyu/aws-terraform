# REQUIRED VARIABLES
variable "vpc_cidr" {
    type = string
}

variable "public_subnet_cidr" {
    description = "The Public Subnet CIDR block of the VPC"
    type        = list
}

variable "private_subnet_cidr" {
    description = "The Private Subnet CIDR block of the VPC"
    type        = list
}

variable "availability_zone" {
    description = "The Availability Zone of the VPC ['ap-northeast-2a', 'ap-northeast-2b', 'ap-northeast-2c', 'ap-northeast-2d']"
    type        = list
}

# OPTIONAL VARIABLES
variable "region" {
    description = "The Region of the VPC"
    default     = "ap-northeast-2"
    type        = string
}

variable "environment" {
    description = "The Profile of the VPC ['prod', 'dev', 'stage', 'test']"
    type        = string
}