locals {
  # Constants

  spec = yamldecode(file(var.spec_file_path))

  database_read_privileges = [
    "USAGE",
  ]

  database_write_privileges = [
    "USAGE",
    "MONITOR",
    "CREATE SCHEMA",
  ]

  schema_read_privileges = [
    "USAGE",
  ]

  schema_write_privileges = [
    "USAGE",
    "MONITOR",
    "CREATE TABLE",
    "CREATE VIEW",
    "CREATE STAGE",
    "CREATE FILE FORMAT",
    "CREATE SEQUENCE",
    "CREATE FUNCTION",
    "CREATE PIPE",
  ]

  table_read_privileges = [
    "SELECT",
  ]

  table_write_privileges = [
    "SELECT",
    "INSERT",
    "UPDATE",
    "DELETE",
    "TRUNCATE",
    "REFERENCES",
  ]

  view_read_privileges = [
    "SELECT",
  ]

  view_write_privileges = [
    "SELECT",
    "REFERENCES",
  ]

  warehouse_privileges = [
    "USAGE",
    "OPERATE",
    "MONITOR",
  ]



  # Resource Maps

  ## Databases

  databases_with_privileges = {
    for database, spec in local.spec["databases"] : database => spec
    if contains(keys(spec), "privileges")
  }

  databases_with_database_privileges = {
    for database, spec in local.databases_with_privileges : database => spec
    if contains(keys(spec.privileges), "database")
  }

  databases_with_database_read_privileges = {
    for database, spec in local.databases_with_database_privileges : database => spec
    if contains(keys(spec.privileges.database), "read")
  }

  databases_with_database_write_privileges = {
    for database, spec in local.databases_with_database_privileges : database => spec
    if contains(keys(spec.privileges.database), "write")
  }

  database_read_grants = {
    for grant in flatten([
      for privilege in local.database_read_privileges : [
        for database, spec in local.databases_with_database_read_privileges : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles         = [for role in spec.privileges.database.read.roles : upper(role)]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  database_write_grants = {
    for grant in flatten([
      for privilege in local.database_write_privileges : [
        for database, spec in local.databases_with_database_write_privileges : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles         = [for role in spec.privileges.database.write.roles : upper(role)]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  ## Schemas

  databases_with_schema_privileges = {
    for database, spec in local.databases_with_privileges : database => spec
    if contains(keys(spec.privileges), "schemas")
  }

  databases_with_schema_read_privileges = {
    for database, spec in local.databases_with_schema_privileges : database => spec
    if contains(keys(spec.privileges.schema), "read")
  }

  databases_with_schema_write_privileges = {
    for database, spec in local.databases_with_schema_privileges : database => spec
    if contains(keys(spec.privileges.schema), "write")
  }

  schema_read_grants = {
    for grant in flatten([
      for privilege in local.schema_read_privileges : [
        for database, spec in local.databases_with_database_read_privileges : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles         = [for role in spec.privileges.database.read.roles : upper(role)]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  schema_write_grants = {
    for grant in flatten([
      for privilege in local.schema_write_privileges : [
        for database, spec in local.databases_with_database_write_privileges : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles         = [for role in spec.privileges.database.write.roles : upper(role)]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  ### Tables

  databases_with_table_privileges = {
    for database, spec in local.databases_with_privileges : database => spec
    if contains(keys(spec.privileges), "tables")
  }

  databases_with_table_read_privileges = {
    for database, spec in local.databases_with_table_privileges : database => spec
    if contains(keys(spec.privileges.table), "read")
  }

  databases_with_table_write_privileges = {
    for database, spec in local.databases_with_table_privileges : database => spec
    if contains(keys(spec.privileges.table), "write")
  }

  table_read_grants = {
    for grant in flatten([
      for privilege in local.table_read_privileges : [
        for database, spec in local.databases_with_database_read_privileges : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles         = [for role in spec.privileges.database.read.roles : upper(role)]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  table_write_grants = {
    for grant in flatten([
      for privilege in local.table_write_privileges : [
        for database, spec in local.databases_with_database_write_privileges : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles         = [for role in spec.privileges.database.write.roles : upper(role)]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  ### Views

  databases_with_view_privileges = {
    for database, spec in local.databases_with_privileges : database => spec
    if contains(keys(spec.privileges), "views")
  }

  databases_with_view_read_privileges = {
    for database, spec in local.databases_with_view_privileges : database => spec
    if contains(keys(spec.privileges.view), "read")
  }

  databases_with_view_write_privileges = {
    for database, spec in local.databases_with_view_privileges : database => spec
    if contains(keys(spec.privileges.view), "write")
  }

  view_read_grants = {
    for grant in flatten([
      for privilege in local.view_read_privileges : [
        for database, spec in local.databases_with_database_read_privileges : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles         = [for role in spec.privileges.database.read.roles : upper(role)]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  view_write_grants = {
    for grant in flatten([
      for privilege in local.view_write_privileges : [
        for database, spec in local.databases_with_database_write_privileges : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles         = [for role in spec.privileges.database.write.roles : upper(role)]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }


  ## Roles

  roles_with_grants = {
    for role, spec in local.spec["roles"] : role => spec
    if contains(keys(spec), "grant_to")
  }

  roles_with_role_grants = {
    for role, spec in local.roles_with_grants : role => spec
    if contains(keys(spec.grant_to), "roles")
  }

  roles_with_user_grants = {
    for role, spec in local.roles_with_grants : role => spec
    if contains(keys(spec.grant_to), "users")
  }

  role_grants = {
    for grant in flatten([
      for role, spec in local.roles_with_role_grants : {
        role_name = upper(role)
        roles     = [for grant_to_role in spec.grant_to.roles : upper(grant_to_role)]
      }
  ]) : lower(replace("${grant.role_name}", " ", "_")) => grant }

  user_grants = {
    for grant in flatten([
      for role, spec in local.roles_with_user_grants : {
        role_name = upper(role)
        users     = [for grant_to_user in spec.grant_to.users : upper(grant_to_user)]
      }
  ]) : lower(replace("${grant.role_name}", " ", "_")) => grant }

  ## Warehouses

  warehouses_with_privileges = {
    for warehouse, spec in local.spec["warehouses"] : warehouse => spec
    if contains(keys(spec), "privileges")
  }

  warehouse_grants = {
    for grant in flatten([
      for privilege in local.warehouse_privileges : [
        for warehouse, spec in local.warehouses_with_privileges : {
          warehouse_name = upper(warehouse)
          privilege      = upper(privilege)
          roles          = [for role in spec.privileges.roles : upper(role)]
        }
      ]
  ]) : lower(replace("${grant.warehouse_name}_${grant.privilege}", " ", "_")) => grant }
}
