resource "snowflake_warehouse_grant" "warehouse_grants" {
  for_each       = local.warehouse_grants
  warehouse_name = each.value.warehouse_name
  privilege      = each.value.privilege
  roles          = each.value.roles
}
