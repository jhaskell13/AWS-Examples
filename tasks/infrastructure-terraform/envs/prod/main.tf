provider "aws" {
  region = var.aws_region
}

module "network" {
  source               = "../../modules/network"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zone    = var.availability_zone
}

data "aws_ami" "al2023_laravel_base" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-laravel-base"] # Snapshot of AL2023 with `./user_data.sh.tpl` script executed
  }
}

# Create EC2 Instance
module "compute" {
  source              = "../../modules/compute"
  vpc_id              = module.network.vpc_id
  environment         = var.environment
  domain_name         = var.domain_name
  ami_id              = "ami-090b891dabeb3a0ba"
  instance_type       = var.instance_type
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_id   = module.network.private_subnet_ids[0]
  associate_public_ip = true
  key_name            = var.key_pair_name

  iam_instance_profile = module.ec2_role.instance_profile_name

  tags = {
    Name        = "${title(var.environment)}WebServer"
    Environment = var.environment
    CodeDeploy  = "Laravel"
  }
}

# Build CodeDeploy pipeline
module "cicd" {
  source                = "../../modules/cicd"
  environment           = var.environment
  service_role_arn      = module.ec2_role.arn
  alb_target_group_name = module.compute.aws_lb_target_group.name
}