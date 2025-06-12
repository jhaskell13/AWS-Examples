variable "ami_id" {
  type        = string
  description = "AMI ID to use"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "associate_public_ip" {
  type    = bool
  default = true
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
