resource "random_id" "bucket_id" {
  byte_length = 4
}

# Create Versioned S3 Bucket
module "app_bucket" {
  source                         = "../../modules/s3_bucket"
  bucket_name                    = "${var.environment}-app-bucket-${random_id.bucket_id.hex}"
  expire_old_versions_after_days = 14
  enable_public_read             = true

  tags = {
    Purpose     = "App storage"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "s3_bucket_name" {
  name  = "/${var.environment}/s3/bucket_name"
  type  = "String"
  value = module.app_bucket.bucket_name
}