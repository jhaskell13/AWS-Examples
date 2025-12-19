output "environment" {
  value = title(var.environment)
}

output "environment_url" {
  value       = "https://${module.compute.alb_dns}"
  description = "URL to access the environment"
}

output "vpc_id" {
  value       = module.network.vpc_id
  description = "VPC ID"
}

output "alb_dns" {
  value       = module.compute.alb_dns
  description = "ALB DNS name"
}

output "ami_id" {
  value       = data.aws_ami.al2023_laravel_base.id
  description = "AMI ID for al2023-laravel-base"
}

output "instance_id" {
  value       = module.compute.instance_id
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

