#-- networking/main.tf

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az-list" {
  input = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main_vpc-${random_integer.random.id}"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az-list.result[count.index]

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count = var.public_sn_count
  subnet_id = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnet" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone = random_shuffle.az-list.result[count.index]

  tags = {
    Name = "private_subnet_${count.index}"
  }
}


resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  
  tags = {
    Name = "main_igw"
  }
}

resource "aws_route_table" "public_rt"{
  vpc_id = aws_vpc.main_vpc.id
  
  tags = {
    Name = "public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_igw.id
}

resource "aws_default_route_table" "private_rt"{
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id
  
  tags = {
    Name = "private_rt"
  }
}

resource "aws_security_group" "main_sg" {
  for_each = var.security_groups
  name = each.value.name
  description = each.value.description
  vpc_id = aws_vpc.main_vpc.id
  
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port = ingress.value.from
      to_port = ingress.value.to
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" //all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "main_subnet_group"{
  count = var.db_subnet_group == true ? 1 : 0 
  name = "main_subnet_group"
  subnet_ids = aws_subnet.private_subnet.*.id
  
  tags = {
    Name = "main subnet group"
  }
}



