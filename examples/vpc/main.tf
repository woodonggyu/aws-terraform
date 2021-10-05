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

resource "aws_security_group" "main_webservice_security_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80

  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH"
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ALL Outbound"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0

  }

  tags = {
    "Name" = format("%s.sg", lower(var.environment))
  }
}

resource "aws_key_pair" "main_key_pair" {
  key_name = format("%s.keypair", lower(var.environment))
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "main_instance" {
  count                   = 2

  # ubuntu 20.04 LTS
  ami                     = "ami-04876f29fd3a5e8ba"
  availability_zone       = var.availability_zone[count.index]
  instance_type           = "t2.nano"
  subnet_id               = element(aws_subnet.main_private.*.id, count.index)
  key_name                = aws_key_pair.main_key_pair.key_name
  vpc_security_group_ids  = [aws_security_group.main_webservice_security_group.id]

  tags = {
    "Name" = format("%s.private-%s.instance", lower(var.environment), substr(var.availability_zone[count.index], -2, 2))
  }
}

resource "aws_alb" "main_alb" {
  enable_deletion_protection  = false
  internal                    = false
  security_groups             = [aws_security_group.main_webservice_security_group.id]
  subnets                     = aws_subnet.main_public.*.id

  tags = {
    "Name" = format("%s.alb", lower(var.environment))
  }
}

resource "aws_alb_target_group" "main_alb_target_group" {
  port      = 80
  protocol  = "HTTP"
  vpc_id    = aws_vpc.main.id

  tags = {
    "Name" = format("%s.targetgroup", lower(var.environment))
  }
}

resource "aws_alb_target_group_attachment" "main_alb_target_group_attachment" {
  count             = 2
  port              = 80
  target_group_arn  = aws_alb_target_group.main_alb_target_group.arn
  target_id         = element(aws_instance.main_instance.*.id, count.index)
}

resource "aws_alb_listener" "main_alb_listener" {
  load_balancer_arn   = aws_alb.main_alb.arn
  port                = 80
  protocol            = "HTTP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_alb_target_group.main_alb_target_group.arn
  }
}