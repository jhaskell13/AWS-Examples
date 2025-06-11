# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = "${var.name}-vpc" }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr 
  availability_zone = var.availability_zone 
  tags = { Name = "${var.name}-public-subnet" }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr 
  availability_zone = var.availability_zone 
  tags = { Name = "${var.name}-private-subnet" }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "${var.name}-igw" }
}

# Route Table
resource "aws_route_table" "public" { 
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.name}-public-rt" }
}

# Associate RT with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
