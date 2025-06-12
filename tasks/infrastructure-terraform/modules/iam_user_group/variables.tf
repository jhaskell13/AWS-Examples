variable "group_name" {
  type        = string
  description = "IAM group name"
}

variable "policy_name" {
  type        = string
  description = "Inline policy name"
}

variable "inline_policy_statements" {
  type        = list(any)
  description = "List of IAM policy statements"
}
