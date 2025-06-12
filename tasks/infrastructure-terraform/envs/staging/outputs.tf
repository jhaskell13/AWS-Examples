output "environment" {
  value = title(var.name)
}

output "instance_public_ip" {
  value = module.web_server.public_ip
}

output "bucket_name" {
  value = module.app_bucket.bucket_name
}
