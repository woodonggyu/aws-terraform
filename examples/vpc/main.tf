provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
      Owner       = "Donggyu Woo"
      Team        = "Security Engineering"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block  = var.vpc_cidr

  tags = {
    "Name" = format("%s.an2.vpc", lower(var.environment))
  }
}

resource "aws_subnet" "main_public" {
  vpc_id              = aws_vpc.main.id

  count               = length(var.public_subnet_cidr)
  cidr_block          = var.public_subnet_cidr[count.index]
  availability_zone   = var.availability_zone[count.index]

  tags = {
    "Name" = format("%s.public-%s.subnet", lower(var.environment), substr(var.availability_zone[count.index], -2, 2))
  }
}

resource "aws_subnet" "main_private" {
  vpc_id              = aws_vpc.main.id

  count               = length(var.private_subnet_cidr)
  cidr_block          = var.private_subnet_cidr[count.index]
  availability_zone   = var.availability_zone[count.index]

  tags = {
    "Name" = format("%s.private-%s.subnet", lower(var.environment), substr(var.availability_zone[count.index], -2, 2))
  }
}

resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = format("%s.igw", lower(var.environment))
  }
}

resource "aws_route_table" "main_public_route_table" {
  vpc_id  = aws_vpc.main.id

  tags = {
    "Name" = format("%s-public.rt", lower(var.environment))
  }
}

resource "aws_route" "main_public_route" {
  route_table_id          = aws_route_table.main_public_route_table.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.main_internet_gateway.id
}

resource "aws_route_table" "main_private_route_table" {
  vpc_id  = aws_vpc.main.id

  tags = {
    "Name" = format("%s-private.rt", lower(var.environment))
  }
}

resource "aws_route_table_association" "main_public_route_table_association" {
  count           = length(var.public_subnet_cidr)
  subnet_id       = element(aws_subnet.main_public.*.id, count.index)
  route_table_id  = aws_route_table.main_public_route_table.id
}

resource "aws_route_table_association" "main_private_route_table_association" {
  count           = length(var.private_subnet_cidr)
  subnet_id       = element(aws_subnet.main_private.*.id, count.index)
  route_table_id  = aws_route_table.main_private_route_table.id
}