# Create security group
resource "aws_security_group" "web_sg" {
  name        = "${var.name}-web-sg"
  description = "Allow SSH"
  vpc_id      = module.vpc.vpc_id

  # Inbound traffic - allow ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-web-sg"
  }
}

# AL2023 AMI
data "aws_ssm_parameter" "al2023" {
 name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

# Use latest Amazon Linux AMI 
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.al2023.value] 
  }
}

# Create EC2 Instance
module "web_server" {
  source              = "../../modules/ec2"
  ami_id              = data.aws_ami.amazon_linux.id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnet_id
  security_group_ids  = [aws_security_group.web_sg.id]
  associate_public_ip = true
  key_name            = var.key_pair_name

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from EC2" > /home/ec2-user/index.html
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    cp /home/ec2-user/index.html /var/www/html/
  EOF

  iam_instance_profile = module.developer_role.instance_profile_name

  tags = {
    Name        = "${title(var.name)}WebServer"
    Environment = var.name
  }
}
