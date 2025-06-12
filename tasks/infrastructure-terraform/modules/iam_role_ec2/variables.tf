variable "role_name" {
  type = string
}

variable "inline_policy_statements" {
  type        = list(any)
  description = "List of IAM policy statements"
}
