data "terraform_remote_state" "staging" {
  backend = "local"
  config = {
    path = "../../envs/staging/terraform.tfstate"
  }
}

module "developer_user_group" {
  source     = "../../modules/iam_user_group"
  group_name = "Developers"

  policy_name = "DeveloperS3Access-${data.terraform_remote_state.staging.outputs.environment}"
  inline_policy_statements = [
    {
      Effect   = "Allow"
      Action   = ["s3:ListAllMyBuckets"]
      Resource = "*"
    },
    {
      Effect   = "Allow"
      Action   = ["s3:ListBucket"]
      Resource = "arn:aws:s3:::${data.terraform_remote_state.staging.outputs.bucket_name}"
    },
    {
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ]
      Resource = "arn:aws:s3:::${data.terraform_remote_state.staging.outputs.bucket_name}/*"
    }
  ]
}
