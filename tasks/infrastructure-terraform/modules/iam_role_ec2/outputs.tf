output "instance_profile_name" {
  value = aws_iam_instance_profile.main.name
}

output "arn" {
  description = "Service ARN for IAM Role"
  value       = aws_iam_role.main.arn
}