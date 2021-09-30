# REQUIRED VARIABLES
variable "cidr" {
    type    = string
}

# OPTIONAL VARIABLES
variable "region" {
    default = "ap-northeast-2"
    type    = string
}