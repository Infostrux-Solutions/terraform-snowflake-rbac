locals {
  snowflake_managed_roles = [
    "ACCOUNTADMIN",
    "SYSADMIN",
    "SECURITYADMIN",
    "USERADMIN",
    "ORGADMIN",
    "PUBLIC",
  ]

  privileges_r = [
    "SELECT",
  ]

  privileges_rw = [
    "INSERT",
    "UPDATE",
    "DELETE",
  ]

  databases = (length(var.environments) == 0
    ?
    [for stage in var.data_stages : stage]
    :
    flatten([
      for environment in var.environments : [
        for stage in var.data_stages : [
          "${environment}_${stage}"
        ]
      ]
    ])
  )

  database_grants_r = [
    for pair in setproduct(local.databases, local.privileges_r) : {
      database  = pair[0]
      privilege = pair[1]
    }
  ]

  database_grants_rw = [
    for pair in setproduct(local.databases, local.privileges_rw) : {
      database  = pair[0]
      privilege = pair[1]
    }
  ]

  roles = concat(
    [for role in keys(var.role_grants) : role if !contains(local.snowflake_managed_roles, role)],
    [for database in local.databases : "${database}_R"],
    [for database in local.databases : "${database}_RW"],
  )

  user_role_grants = flatten([
    for role, grants in var.role_grants : [
      for grant in grants : {
        role  = role
        grant = grant
      }
      if !contains(formatlist("%s_R", var.data_stages), grant)
      && !contains(formatlist("%s_RW", var.data_stages), grant)
      && !contains(local.snowflake_managed_roles, role)
      && !contains(local.snowflake_managed_roles, grant)
    ]
  ])

  data_stage_role_grants = (length(var.environments) != 0
    ?
    flatten([
      for environment in var.environments : [
        for role, grants in var.role_grants : [
          for grant in grants : {
            role  = role
            grant = "${environment}_${grant}"
          }
          if contains(formatlist("%s_R", var.data_stages), grant)
          || contains(formatlist("%s_RW", var.data_stages), grant)
        ]
      ]
    ])
    :
    flatten([
      for role, grants in var.role_grants : [
        for grant in grants : {
          role  = role
          grant = grant
        }
        if contains(formatlist("%s_R", var.data_stages), grant)
        || contains(formatlist("%s_RW", var.data_stages), grant)
      ]
    ])
  )

  role_grants = concat(local.user_role_grants, local.data_stage_role_grants)

  role_grants_map = {
    for pair in local.role_grants : "${pair.role}_${pair.grant}" => pair
  }

  users = keys(var.user_grants)

  user_grants = flatten([
    for user, grants in var.user_grants : [
      for grant in grants : {
        user  = user
        grant = grant
      }
      if !contains(local.snowflake_managed_roles, user)
      && !contains(local.snowflake_managed_roles, grant)
    ]
  ])

  user_grants_map = {
    for pair in local.user_grants : "${pair.user}_${pair.grant}" => pair
  }
}
