# Create IAM Role to allow S3 uploads via the EC2 instance
module "developer_role" {
  source     = "../../modules/iam_role_ec2"
  role_name  = "${title(var.name)}DeveloperRole"

  inline_policy_statements = [
    # Full Read access to S3 bucket in this env
    {
      Effect = "Allow"
      Action = ["s3:ListAllMyBuckets", "s3:ListBucket"]
      Resource = "arn:aws:s3:::${module.app_bucket.bucket_name}"
    },
    # Full Write access to S3 bucket in this env
    {
      Effect = "Allow"
      Action = ["s3:GetObject", "s3:PutObject"],
      Resource = "arn:aws:s3:::${module.app_bucket.bucket_name}/*"
    }
  ]
}
