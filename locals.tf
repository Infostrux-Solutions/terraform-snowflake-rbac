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

  database_read_grants = { for combination in flatten([
    for environment in local.spec["environments"] : [
      for stage in keys(local.spec["stages"]) : [
        for privilege in local.database_read_privileges : {
          role      = upper("${environment}_${stage}_R")
          privilege = upper(privilege)
          database  = upper("${environment}_${stage}")
        }
      ]
    ]
  ]) : lower(replace("${combination.privilege}_${combination.database}", " ", "_")) => combination }

  database_write_grants = { for combination in flatten([
    for environment in local.spec["environments"] : [
      for stage in keys(local.spec["stages"]) : [
        for privilege in local.database_write_privileges : {
          role      = upper("${environment}_${stage}_RW")
          privilege = upper(privilege)
          database  = upper("${environment}_${stage}")
        }
      ]
    ]
  ]) : lower(replace("${combination.privilege}_${combination.database}", " ", "_")) => combination }

  ## Schemas

  schema_read_grants = { for combination in flatten([
    for environment in local.spec["environments"] : [
      for stage in keys(local.spec["stages"]) : [
        for privilege in local.schema_read_privileges : {
          role      = upper("${environment}_${stage}_R")
          privilege = upper(privilege)
          database  = upper("${environment}_${stage}")
        }
      ]
    ]
  ]) : lower(replace("${combination.privilege}_${combination.database}", " ", "_")) => combination }

  schema_write_grants = { for combination in flatten([
    for environment in local.spec["environments"] : [
      for stage in keys(local.spec["stages"]) : [
        for privilege in local.schema_write_privileges : {
          role      = upper("${environment}_${stage}_RW")
          privilege = upper(privilege)
          database  = upper("${environment}_${stage}")
        }
      ]
    ]
  ]) : lower(replace("${combination.privilege}_${combination.database}", " ", "_")) => combination }

  ## Tables

  table_read_grants = { for combination in flatten([
    for environment in local.spec["environments"] : [
      for stage in keys(local.spec["stages"]) : [
        for privilege in local.table_read_privileges : {
          role      = upper("${environment}_${stage}_R")
          privilege = upper(privilege)
          database  = upper("${environment}_${stage}")
        }
      ]
    ]
  ]) : lower(replace("${combination.privilege}_${combination.database}", " ", "_")) => combination }

  table_write_grants = { for combination in flatten([
    for environment in local.spec["environments"] : [
      for stage in keys(local.spec["stages"]) : [
        for privilege in local.table_write_privileges : {
          role      = upper("${environment}_${stage}_RW")
          privilege = upper(privilege)
          database  = upper("${environment}_${stage}")
        }
      ]
    ]
  ]) : lower(replace("${combination.privilege}_${combination.database}", " ", "_")) => combination }
}
