# IAM User Group creation
# Creates User Group and IAM Policy, attaches policy to group

resource "aws_iam_group" "main" {
  name = var.group_name
}

resource "aws_iam_policy" "inline" {
  name = var.policy_name

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = var.inline_policy_statements
  })
}

resource "aws_iam_group_policy_attachment" "main" {
  group      = aws_iam_group.main.name
  policy_arn = aws_iam_policy.inline.arn
}
