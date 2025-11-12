variable "environment" {
  description = "Environment name prefix"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
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

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "haskellsolutions.com"
}

variable "app_port" {
  description = "Port of application instance"
  type        = number
  default     = 80
}

variable "db_engine" {
  description = "Engine for RDS instnace"
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "Port for RDS instance"
  type        = number
  default     = 5432
}

variable "db_version" {
  description = "Version of database"
  type        = string
  default     = "17.6"
}

variable "db_size" {
  description = "Database size"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Username for database"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Password for database"
  type        = string
  default     = "dbadmin"
}
