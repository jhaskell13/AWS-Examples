output "public_ip" {
  value = aws_instance.main.public_ip
}

output "instance_id" {
  value = aws_instance.main.id
}

output "public_dns" {
  value = aws_instance.main.public_dns
}
