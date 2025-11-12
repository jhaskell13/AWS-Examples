# Create IAM Role to allow S3 uploads via the EC2 instance
module "ec2_role" {
  source    = "../../modules/iam_role_ec2"
  role_name = "${title(var.environment)}EC2Role"

  inline_policy_statements = [
    # Full Read access to S3 bucket in this env
    {
      Effect   = "Allow"
      Action   = ["s3:ListAllMyBuckets", "s3:ListBucket"]
      Resource = "arn:aws:s3:::${module.app_bucket.bucket_name}"
    },
    # Full Write access to S3 bucket in this env
    {
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:PutObject"],
      Resource = "arn:aws:s3:::${module.app_bucket.bucket_name}/*"
    },
    # Allow EC2 to read DB credentials
    {
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = resource.aws_secretsmanager_secret_version.db_credentials.arn
    }
  ]
}