resource "snowflake_role_grants" "role_grants" {
  for_each  = local.role_grants
  role_name = each.value.role_name
  roles     = each.value.roles
}

resource "snowflake_role_grants" "user_grants" {
  for_each  = local.user_grants
  role_name = each.value.role_name
  users     = each.value.users
}
