resource "aws_iam_role" "main" {
  name = var.role_name

  # Allow EC2 to assume roles
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "main" {
  name = "${var.role_name}Policy"
  role = aws_iam_role.main.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = var.inline_policy_statements 
  })
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.role_name}Profile"
  role = aws_iam_role.main.name
}
