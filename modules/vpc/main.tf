resource "aws_vpc" "three_tier_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

resource "aws_internet_gateway" "three_tier_igw" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = {
    Name = "${var.app_name}-igw"
  }
}

# Public subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets_cidr_block)
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = var.public_subnets_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.app_name}-public-subnet-${count.index}"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three_tier_igw.id
  }
}

resource "aws_route_table_association" "public_subnets" {
  count          = length(var.public_subnets_cidr_block)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_security_group" "three_tier_sg" {
  name        = "${var.app_name}-public-sg"
  description = "Security group for ${var.app_name} application"

  vpc_id = aws_vpc.three_tier_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# NAT gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "${var.app_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${var.app_name}-nat-gateway"
  }
}

# Private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidr_block)
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = var.private_subnets_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.app_name}-private-subnet-${count.index}"
  }
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.three_tier_vpc.id

  depends_on = [aws_eip.nat_eip, aws_nat_gateway.nat_gateway]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "private_subnets" {
  count          = length(var.private_subnets_cidr_block)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}

# Private securiry group
resource "aws_security_group" "private_sg" {
  name        = "${var.app_name}-private-sg"
  description = "Security group for ${var.app_name} application"

  vpc_id = aws_vpc.three_tier_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Database subnets
resource "aws_subnet" "database_subnets" {
  count             = length(var.database_subnets_cidr_block)
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = var.database_subnets_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.app_name}-database-subnet-${count.index}"
  }
}

resource "aws_route_table" "database_rtb" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "database_subnets" {
  count          = length(var.database_subnets_cidr_block)
  subnet_id      = aws_subnet.database_subnets[count.index].id
  route_table_id = aws_route_table.database_rtb.id
}
