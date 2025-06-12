output "group_name" {
  value = aws_iam_group.main.name
}

output "policy_arn" {
  value = aws_iam_policy.inline.arn
}

