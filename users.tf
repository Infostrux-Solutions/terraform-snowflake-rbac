resource "snowflake_role_grants" "user_grants" {
  provider  = snowflake.securityadmin
  for_each  = local.user_grants
  role_name = each.value.role_name
  users     = each.value.users
}
