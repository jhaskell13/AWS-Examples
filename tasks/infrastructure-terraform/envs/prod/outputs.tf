output "environment" {
  value = title(var.environment)
}

output "environment_url" {
  value       = "http://${aws_lb.main.dns_name}"
  description = "URL to access the environment"
}

output "alb_dns" {
  value       = aws_lb.main.dns_name
  description = "ALB DNS name"
}

output "instance_id" {
  value       = module.web_server.instance_id
  description = "EC2 Instance ID"
}

output "database_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = "Database endpoint"
}

output "database_secret_arn" {
  value       = aws_secretsmanager_secret.db_credentials.arn
  description = "ARN of the database credentials secret"
}

output "bucket_name" {
  value = module.app_bucket.bucket_name
}

