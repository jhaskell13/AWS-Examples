# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "${var.environment}-vpc" }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Public Subnet
resource "aws_subnet" "public" {
  for_each          = toset(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[index(var.public_subnet_cidrs, each.value)]
  tags              = { Name = "${var.environment}-public-subnet-${index(var.public_subnet_cidrs, each.value) + 1}" }
}

# Private Subnet
resource "aws_subnet" "private" {
  for_each          = toset(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[index(var.private_subnet_cidrs, each.value)]
  tags              = { Name = "${var.environment}-private-subnet-${index(var.private_subnet_cidrs, each.value) + 1}" }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.environment}-igw" }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.environment}-public-rt" }
}

# Associate RT with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
