variable "environment" {
  description = "Environment prefix for resource names"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnet"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnet"
  type        = list(string)
}

variable "availability_zone" {
  description = "Availability zone for subnets"
  type        = string
}