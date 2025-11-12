# module "vpc" {
#   source              = "../../modules/vpc"
#   name                = var.environment
#   vpc_cidr            = var.vpc_cidr
#   public_subnet_cidr  = var.public_subnet_cidr
#   private_subnet_cidr = var.private_subnet_cidr
#   availability_zone   = var.availability_zone
# }

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_integer" "vpc_octet" {
  min = 10
  max = 250

  keepers = {
    # Regenerate if environment changes
    environment = var.environment
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  name    = "${var.environment}-vpc"

  cidr            = "10.${random_integer.vpc_octet.result}.0.0/16"
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.${random_integer.vpc_octet.result}.1.0/24", "10.${random_integer.vpc_octet.result}.2.0/24"]
  public_subnets  = ["10.${random_integer.vpc_octet.result}.101.0/24", "10.${random_integer.vpc_octet.result}.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true # Cost optimization
  enable_dns_hostnames = true
}

# Route53
data "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.environment == "production" ? var.domain_name : "${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
