resource "snowflake_role_grants" "role_grants" {
  provider  = snowflake.securityadmin
  for_each  = local.role_grants
  role_name = each.value.role_name
  roles     = each.value.roles
}
