provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block  = var.vpc_cidr

  tags        = {
    Name      = "${var.vpc_name}.an2.vpc"
  }
}

resource "aws_subnet" "main_public" {
  vpc_id              = aws_vpc.main.id

  count               = length(var.public_subnet_cidr)
  cidr_block          = var.public_subnet_cidr[count.index]
  availability_zone   = var.availability_zone[count.index]

  tags                = {
    Name              = "${var.vpc_profile}.public-${substr("${var.availability_zone[count.index]}", -2, 2)}.subnet"
  }
}

resource "aws_subnet" "main_private" {
  vpc_id              = aws_vpc.main.id

  count               = length(var.private_subnet_cidr)
  cidr_block          = var.private_subnet_cidr[count.index]
  availability_zone   = var.availability_zone[count.index]

  tags                = {
    Name              = "${var.vpc_profile}.private-${substr("${var.availability_zone[count.index]}", -2, 2)}.subnet"
  }
}

resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id  = aws_vpc.main.id

  tags    = {
    Name  = "${var.vpc_profile}.igw"
  }
}

resource "aws_route_table" "main_public_route_table" {
  vpc_id  = aws_vpc.main.id

  tags    = {
    Name  = "${var.vpc_profile}-public.rt"
  }
}

resource "aws_route" "main_public_route" {
  route_table_id          = aws_route_table.main_public_route_table.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.main_internet_gateway.id
}

resource "aws_route_table" "main_private_route_table" {
  vpc_id  = aws_vpc.main.id

  tags    = {
    Name  = "${var.vpc_profile}-private.rt"
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