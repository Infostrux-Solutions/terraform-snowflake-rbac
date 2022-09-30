# Database Privileges

resource "snowflake_database_grant" "database_read_grants" {
  provider      = snowflake.securityadmin
  for_each      = local.database_read_grants
  database_name = each.value.database_name
  privilege     = each.value.privilege
  roles         = each.value.roles
}

resource "snowflake_database_grant" "database_write_grants" {
  provider      = snowflake.securityadmin
  for_each      = local.database_write_grants
  database_name = each.value.database_name
  privilege     = each.value.privilege
  roles         = each.value.roles
}

# Schema Privileges

resource "snowflake_schema_grant" "schema_read_grants" {
  provider          = snowflake.securityadmin
  for_each          = local.schema_read_grants
  database_name     = each.value.database_name
  privilege         = each.value.privilege
  roles             = each.value.roles
  on_future         = true
  with_grant_option = false
}

resource "snowflake_schema_grant" "schema_write_grants" {
  provider          = snowflake.securityadmin
  for_each          = local.schema_write_grants
  database_name     = each.value.database_name
  privilege         = each.value.privilege
  roles             = each.value.roles
  on_future         = true
  with_grant_option = false
}

# Table Privileges

resource "snowflake_table_grant" "table_read_grants" {
  provider          = snowflake.securityadmin
  for_each          = local.table_read_grants
  database_name     = each.value.database_name
  privilege         = each.value.privilege
  roles             = each.value.roles
  on_future         = true
  with_grant_option = false
}

resource "snowflake_table_grant" "table_write_grants" {
  provider          = snowflake.securityadmin
  for_each          = local.table_write_grants
  database_name     = each.value.database_name
  privilege         = each.value.privilege
  roles             = each.value.roles
  on_future         = true
  with_grant_option = false
}
