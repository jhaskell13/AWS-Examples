resource "aws_security_group" "db" {
  name_prefix = "${var.environment}-db-"
  vpc_id      = module.vpc.vpc_id
  description = "Security group for database"

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_instance" "main" {
  identifier     = "${var.environment}-db"
  engine         = var.db_engine
  engine_version = var.db_version
  instance_class = var.db_size

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true

  db_name                     = "${title(var.environment)}DB"
  username                    = var.db_username
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  skip_final_snapshot       = true
  final_snapshot_identifier = null
  deletion_protection       = false

  backup_retention_period = 0

  publicly_accessible = false
}

# Configure DB credentials secret, managed by RDS via `manage_master_user_password = true` on the instance
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.environment}-db-credentials"
}

data "aws_secretsmanager_secret" "rds_master" {
  arn = aws_db_instance.main.master_user_secret[0].secret_arn
}

# get the latest secret value
data "aws_secretsmanager_secret_version" "rds_master_value" {
  secret_id = data.aws_secretsmanager_secret.rds_master.id
}

locals {
  rds_secret_data = jsondecode(data.aws_secretsmanager_secret_version.rds_master_value.secret_string)
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    environment = var.environment
    username    = local.rds_secret_data.username
    password    = local.rds_secret_data.password
    engine      = aws_db_instance.main.engine
    host        = aws_db_instance.main.address
    port        = aws_db_instance.main.port
    dbname      = aws_db_instance.main.db_name
    url         = "postgresql://${local.rds_secret_data.username}:${local.rds_secret_data.password}@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${aws_db_instance.main.db_name}"
  })
}