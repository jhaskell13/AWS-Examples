resource "random_id" "bucket_id" {
  byte_length = 4
}

# Create Versioned S3 Bucket
module "app_bucket" {
  source                         = "../../modules/s3_bucket"
  bucket_name                    = "${var.name}-app-bucket-${random_id.bucket_id.hex}"
  expire_old_versions_after_days = 14
  enable_public_read             = true

  tags = {
    Purpose     = "App storage"
    Environment = var.name
  }
}
