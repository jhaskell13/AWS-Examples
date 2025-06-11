variable "name" {
  description = "Environment name prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
}

variable "availability_zone" {
  description = "AZ for the subnets"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
}

variable "key_pair_name" {
  description = "Name of existing EC2 key pair"
  type        = string
}
