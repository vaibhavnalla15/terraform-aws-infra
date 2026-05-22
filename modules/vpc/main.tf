# VPC section:- Creates the main VPC for application infrastructure

resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}

# Creates Internet Gateway for public internet access
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

# Creat public subnets
resource "aws_subnet" "public-subnet" {
  count                   = length(var.public-subnet-cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public-subnet-cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-${count.index + 1}"
  }
}

# Creat private subnets
resource "aws_subnet" "private-subnet" {
  count                   = length(var.private-subnet-cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private-subnet-cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
  }
}

# Public route table for internet-facing subnets
resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
}

# Route table association to public subnets
resource "aws_route_table_association" "name" {
  count = length(var.public-subnet-cidr)

  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.main-rt.id
}

# Creates Elastic IP for NAT Gateway internet access
resource "aws_eip" "nat_eip" {

  # Ensures Internet Gateway exists before allocating EIP
  depends_on = [aws_internet_gateway.main-igw ]

  # Tags for identification
  tags = {
    Name = "${var.environment}-nat-eip"
  }
}

# Creates NAT Gateway for private subnet outbound internet access
resource "aws_nat_gateway" "main_nat" {

  # Elastic IP attached to NAT Gateway
  allocation_id = aws_eip.nat_eip.id

  # NAT Gateway must be placed inside a PUBLIC subnet
  subnet_id = aws_subnet.public-subnet[0].id

  # Tags for identification
  tags = {
    Name = "${var.environment}-nat-gateway"
  }

  # Ensures Internet Gateway exists first
  depends_on = [aws_internet_gateway.main-igw]
}

# Creates private route table for private subnets
resource "aws_route_table" "private_rt" {

  # attach route table to VPC
  vpc_id = aws_vpc.main.id

  # Route outbound internet traffic through NAT Gateway
  route {
    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.main_nat.id
  }

  # Tags for Identification
  tags = {
    Name = "${var.environment}-private-route-table"
  }
}

# Associates all private subnets with private route table
resource "aws_route_table_association" "private_rt_asso" {

  # Creates association for each private subnet
  count = length(var.private-subnet-cidr)

  # Private subnet IDs
  subnet_id = aws_subnet.private-subnet[count.index].id

  # Private route table ID
  route_table_id = aws_route_table.private_rt.id
}