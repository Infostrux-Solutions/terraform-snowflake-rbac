locals {
  # Constants
  snowflake_default_roles = [
    "ACCOUNTADMIN",
    "SYSADMIN",
    "SECURITYADMIN",
    "USERADMIN",
    "PUBLIC",
  ]

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

  warehouse_privileges = [
    "USAGE",
    "OPERATE",
    "MONITOR",
  ]

  spec = yamldecode(file("${path.module}/spec.yml"))

  # Resource Maps

  ## Databases

  roles_with_database_grants = {
    for role, spec in local.spec["roles"] : role => spec
    if contains(keys(spec), "databases")
  }

  roles_with_database_read_grants = {
    for role, spec in local.roles_with_database_grants : role => spec
    if contains(keys(spec.databases), "read")
  }

  roles_with_database_write_grants = {
    for role, spec in local.roles_with_database_grants : role => spec
    if contains(keys(spec.databases), "write")
  }

  databases_with_read_grants = distinct(flatten([
    for role, spec in local.roles_with_database_read_grants : spec.databases.read
  ]))

  databases_with_write_grants = distinct(flatten([
    for role, spec in local.roles_with_database_write_grants : spec.databases.write
  ]))

  database_read_grants = {
    for grant in flatten([
      for privilege in local.database_read_privileges : [
        for database in local.databases_with_read_grants : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles = [
            for role, spec in local.roles_with_database_read_grants : upper(role)
            if contains(spec.databases.read, "${database}")
          ]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  database_write_grants = {
    for grant in flatten([
      for privilege in local.database_write_privileges : [
        for database in local.databases_with_write_grants : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles = [
            for role, spec in local.roles_with_database_write_grants : upper(role)
            if contains(spec.databases.write, "${database}")
          ]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  ## Schemas

  schema_read_grants = {
    for grant in flatten([
      for privilege in local.schema_read_privileges : [
        for database in local.databases_with_read_grants : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles = [
            for role, spec in local.roles_with_database_read_grants : upper(role)
            if contains(spec.databases.read, "${database}")
          ]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  schema_write_grants = {
    for grant in flatten([
      for privilege in local.schema_write_privileges : [
        for database in local.databases_with_write_grants : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles = [
            for role, spec in local.roles_with_database_write_grants : upper(role)
            if contains(spec.databases.write, "${database}")
          ]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  ## Tables

  table_read_grants = {
    for grant in flatten([
      for privilege in local.table_read_privileges : [
        for database in local.databases_with_read_grants : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles = [
            for role, spec in local.roles_with_database_read_grants : upper(role)
            if contains(spec.databases.read, "${database}")
          ]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  table_write_grants = {
    for grant in flatten([
      for privilege in local.table_write_privileges : [
        for database in local.databases_with_write_grants : {
          database_name = upper(database)
          privilege     = upper(privilege)
          roles = [
            for role, spec in local.roles_with_database_write_grants : upper(role)
            if contains(spec.databases.write, "${database}")
          ]
        }
      ]
  ]) : lower(replace("${grant.database_name}_${grant.privilege}", " ", "_")) => grant }

  ## Roles

  roles_to_grant_to_roles = distinct(flatten([
    for role, spec in local.spec["roles"] : spec.roles
  ]))

  role_grants = {
    for grant in flatten([
      for role_to_grant in local.roles_to_grant_to_roles : {
        role_name = upper(role_to_grant)
        roles = [
          for role, spec in local.spec["roles"] : upper(role)
          if contains(spec.roles, "${role_to_grant}")
        ]
      }
  ]) : lower(replace("${grant.role_name}", " ", "_")) => grant }

  ## Users

  roles_to_grant_to_users = distinct(flatten([
    for user, spec in local.spec["users"] : spec.roles
  ]))

  user_grants = {
    for grant in flatten([
      for role_to_grant in local.roles_to_grant_to_users : {
        role_name = upper(role_to_grant)
        users = [
          for user, spec in local.spec["users"] : upper(user)
          if contains(spec.roles, "${role_to_grant}")
        ]
      }
  ]) : lower(replace("${grant.role_name}", " ", "_")) => grant }
}
