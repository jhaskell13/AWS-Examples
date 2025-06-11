provider "aws" {
    region = "us-east-2"
}

# Spin up VPC
module "vpc" {
    source = "../../modules/vpc"
    name = var.name
    vpc_cidr = var.vpc_cidr 
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr 
    availability_zone = var.availability_zone
}

# Begin spinning up EC2 instance

# Create security group
resource "aws_security_group" "web_sg" {
  name = "web-sg"
  description = "Allow SSH"
  vpc_id = module.vpc.vpc_id

  # Inbound traffic
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Use latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create EC2 Instance
module "web_server" {
  source = "../../modules/ec2"
  ami_id = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnet_id
  security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip = true
  key_name = var.key_pair_name

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from EC2" > /home/ec2-user/index.html
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    cp /home/ec2-user/index.html /var/www/html/
  EOF

  tags = {
    Name = "web-server"
    Environment = var.name
  }
}

output "instance_public_ip" {
  value = module.web_server.public_ip
}
