# Configure CodeDeploy to handle deployments to EC2 instance
resource "aws_codedeploy_app" "laravel_app" {
  name             = "laravel-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "laravel_deployment_group" {
  app_name              = aws_codedeploy_app.laravel_app.name
  deployment_group_name = "laravel-deployment-group"
  service_role_arn      = var.service_role_arn

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
      name = var.alb_target_group_name
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