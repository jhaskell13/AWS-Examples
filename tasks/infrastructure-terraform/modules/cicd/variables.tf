variable "environment" {
  description = "Environment"
  type        = string
}

variable "service_role_arn" {
  description = "Service role ARN for deployment group"
  type        = string
}

variable "alb_target_group_name" {
  description = "Name of the ALB target group"
  type        = string
}