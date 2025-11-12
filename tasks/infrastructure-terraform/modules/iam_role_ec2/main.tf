resource "aws_iam_role" "main" {
  name = var.role_name

  # Allow EC2 to assume roles
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        },
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

# CodeDeploy Policy
resource "aws_iam_role_policy_attachment" "codedeploy_access" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.role_name}Profile"
  role = aws_iam_role.main.name
}
