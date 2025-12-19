output "public_ip" {
  value = aws_instance.main.public_ip
}

output "instance_id" {
  value = aws_instance.main.id
}

output "public_dns" {
  value = aws_instance.main.public_dns
}

output "security_group_id" {
  value = aws_security_group.ec2.id
}

output "aws_lb_target_group" {
  value = aws_lb_target_group.app
}

output "alb_dns" {
  value = aws_lb.main.dns_name
}
