provider "aws" {
  region = var.region

}

resource "aws_vpc" "main" {
  cidr_block = var.cidr
}