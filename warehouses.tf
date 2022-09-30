resource "snowflake_warehouse_grant" "warehouse_grants" {
  provider       = snowflake.securityadmin
  for_each       = local.warehouse_grants
  warehouse_name = each.value.warehouse_name
  privilege      = each.value.privilege
  roles          = each.value.roles
}
