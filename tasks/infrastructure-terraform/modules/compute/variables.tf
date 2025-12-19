variable "environment" {
  description = "Environment"
  type        = string
}

variable "domain_name" {
  description = "Domain of current environment"
  type        = string
}

variable "app_port" {
  description = "App port"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocol for ALB Target Group"
  type        = string
  default     = "HTTP"
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_id" {
  type = string
}

variable "associate_public_ip" {
  type    = bool
  default = false
}

variable "key_name" {
  type = string
}

variable "user_data" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "vpc_id" {
  type = string
}
