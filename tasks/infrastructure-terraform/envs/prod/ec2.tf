# Create security group
resource "aws_security_group" "ec2" {
  name_prefix = "${var.environment}-ec2-"
  description = "Allow traffic from ALB on App Port"
  vpc_id      = module.vpc.vpc_id

  # Allow traffic from ALB Security Group
  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # REMOVE THIS AND MOVE INSTANCE BACK TO PRIVATE SUBNET
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["67.186.130.212/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
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

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = "github/token"
}

# Create EC2 Instance
module "web_server" {
  source              = "../../modules/ec2"
  ami_id              = data.aws_ami.amazon_linux.id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnets[0]
  security_group_ids  = [aws_security_group.ec2.id]
  associate_public_ip = true
  key_name            = var.key_pair_name

  user_data = replace(templatefile("${path.module}/user_data.sh.tpl", {
    github_token  = data.aws_secretsmanager_secret_version.github_token.secret_string
    region        = var.aws_region
    app_env       = var.environment
    db_connection = var.db_engine == "postgres" ? "pgsql" : var.db_engine
    db_host       = aws_db_instance.main.address
    db_port       = aws_db_instance.main.port
    db_name       = aws_db_instance.main.db_name
    db_username   = aws_db_instance.main.username
    db_password   = data.aws_secretsmanager_secret_version.rds_master_value.secret_string
  }), "\r", "")

  iam_instance_profile = module.ec2_role.instance_profile_name

  tags = {
    Name        = "${title(var.environment)}WebServer"
    Environment = var.environment
    CodeDeploy  = "Laravel"
  }
}

# Configure CodeDeploy to handle deployments to EC2 instance
resource "aws_codedeploy_app" "laravel_app" {
  name             = "laravel-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "laravel_deployment_group" {
  app_name              = aws_codedeploy_app.laravel_app.name
  deployment_group_name = "laravel-deployment-group"
  service_role_arn      = module.ec2_role.arn

  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "CodeDeploy"
      value = "Laravel"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.app.name
    }
  }
}

# Store names in SSM
resource "aws_ssm_parameter" "codedeploy_app" {
  name  = "/${var.environment}/codedeploy/app_name"
  type  = "String"
  value = aws_codedeploy_app.laravel_app.name
}

resource "aws_ssm_parameter" "codedeploy_deployment_group" {
  name  = "/${var.environment}/codedeploy/deployment_group_name"
  type  = "String"
  value = aws_codedeploy_deployment_group.laravel_deployment_group.deployment_group_name
}

