resource "snowflake_role" "roles" {
  provider = snowflake.useradmin
  for_each = toset(local.roles)
  name     = each.key
}

resource "snowflake_role_grants" "role_grants" {
  provider = snowflake.securityadmin
  for_each = {
    for pair in local.role_grants_map : "${pair.role}.${pair.grant}" => pair
  }
  role_name = snowflake_role.roles[each.value.role].name
  roles     = [snowflake_role.roles[each.value.grant].name]
}
