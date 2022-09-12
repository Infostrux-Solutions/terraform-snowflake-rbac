resource "snowflake_database" "databases" {
  provider = snowflake.sysadmin
  for_each = toset(local.databases)
  name     = each.key
}

resource "snowflake_database_grant" "database_grants" {
  provider      = snowflake.securityadmin
  for_each      = toset(local.databases)
  database_name = snowflake_database.databases[each.key].name
  privilege     = "USAGE"
  roles = [
    snowflake_role.roles["${each.key}_R"].name,
    snowflake_role.roles["${each.key}_RW"].name
  ]
}

resource "snowflake_schema_grant" "schema_grants" {
  provider      = snowflake.securityadmin
  for_each      = toset(local.databases)
  database_name = snowflake_database.databases[each.key].name
  privilege     = "USAGE"
  roles = [
    snowflake_role.roles["${each.key}_R"].name,
    snowflake_role.roles["${each.key}_RW"].name
  ]
  on_future         = true
  with_grant_option = false
}

resource "snowflake_table_grant" "table_grants_r" {
  provider = snowflake.securityadmin
  for_each = {
    for grant in local.database_grants_r : "${grant.database}.${grant.privilege}" => grant
  }
  database_name = snowflake_database.databases[each.value.database].name
  privilege     = each.value.privilege
  roles = [
    snowflake_role.roles["${each.value.database}_R"].name,
    snowflake_role.roles["${each.value.database}_RW"].name,
  ]
  on_future         = true
  with_grant_option = false
}

resource "snowflake_table_grant" "table_grants_rw" {
  provider = snowflake.securityadmin
  for_each = {
    for grant in local.database_grants_rw : "${grant.database}.${grant.privilege}" => grant
  }
  database_name     = snowflake_database.databases[each.value.database].name
  privilege         = each.value.privilege
  roles             = [snowflake_role.roles["${each.value.database}_RW"].name]
  on_future         = true
  with_grant_option = false
}
