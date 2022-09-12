resource "snowflake_user" "users" {
  provider = snowflake.useradmin
  for_each = toset(local.users)
  name     = each.key
}

resource "snowflake_role_grants" "user_grants" {
  provider = snowflake.securityadmin
  for_each = {
    for pair in local.user_grants_map : "${pair.user}.${pair.grant}" => pair
  }
  role_name = snowflake_role.roles[each.value.grant].name
  users     = [snowflake_user.users[each.value.user].name]
}
