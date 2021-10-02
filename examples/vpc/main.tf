provider "aws" {
  region = var.region

}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.vpc_name}.an2.vpc"
  }
}

resource "aws_subnet" "main_public" {
  vpc_id              = aws_vpc.main.id

  count               = length(var.public_subnet_cidr)
  cidr_block          = var.public_subnet_cidr[count.index]
  availability_zone   = var.availability_zone[count.index]
  tags = {
    Name = "${var.vpc_profile}.public-${substr("${var.availability_zone[count.index]}", -2, 2)}.subnet"
  }
}

resource "aws_subnet" "main_private" {
  vpc_id              = aws_vpc.main.id

  count               = length(var.private_subnet_cidr)
  cidr_block          = var.private_subnet_cidr[count.index]
  availability_zone   = var.availability_zone[count.index]
  tags = {
    Name = "${var.vpc_profile}.private-${substr("${var.availability_zone[count.index]}", -2, 2)}.subnet"
  }
}