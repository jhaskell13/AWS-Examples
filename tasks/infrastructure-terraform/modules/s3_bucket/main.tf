resource "aws_s3_bucket" "main" {
  bucket        = var.bucket_name
  force_destroy = true # Auto-delete all objects on destroy

  tags = var.tags
}

# resource "aws_s3_bucket_acl" "main" {
#     bucket = aws_s3_bucket.main.id
#     acl    = "private"
# }

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  # We want old versions to expire after X days of non-use
  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    filter {
      prefix = "config/"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.expire_old_versions_after_days
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  block_public_policy = var.enable_public_read ? false : true
}


resource "aws_s3_bucket_policy" "public_read" {
  count  = var.enable_public_read ? 1 : 0
  bucket = aws_s3_bucket.main.id

  # Allow anyone to download/view objects on this bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.main.arn}/*"
      }
    ]
  })

  # Ensure we can apply this policy, depending on the public access block resource being created first
  depends_on = [
    aws_s3_bucket_public_access_block.main
  ]
}

# Enable CORS
resource "aws_s3_bucket_cors_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}
