output "dev_users" {
  value = {
    for user, mod in module.developer_users :
    user => {
      user_name = mod.user_name
    }
  }
}
