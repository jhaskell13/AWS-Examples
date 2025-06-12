resource "aws_iam_user" "main" {
  name = var.user_name
}

resource "aws_iam_user_group_membership" "membership" {
  user = aws_iam_user.main.name
  groups = [var.group_name]
}
