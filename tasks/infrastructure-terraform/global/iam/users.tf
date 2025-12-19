locals {
  user_names = [
    "jhaskell"
  ]
}

module "developer_users" {
  source     = "../../modules/iam_user"
  for_each   = toset(local.user_names)
  user_name  = each.key
  group_name = module.developer_user_group.group_name
}
