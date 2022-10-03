# terraform-snowflake-rbac

Quickly deploy Snowflake RBAC resources using a simple configuration model.

This module assumes the resources specified have been created in Snowflake by other means (e.g. through the Snowflake UI, using DDL commands or another Terraform project). In other words, no resources are created using this module, rather they are associated using their respective `snowflake_*_grant` Terraform resource blocks.

## TODO

- [ ] Update schema privileges to use spec.yml
- [ ] Update table privileges to use spec.yml
- [ ] Add a CI pipeline
- [ ] Convert this to a proper module and update the README's usage section

## Usage

```hcl
module "rbac" {
  source = "Infostrux-Solutions/terraform-snowflake-rbac"

  providers = {
    snowflake.useradmin     = snowflake.useradmin
    snowflake.securityadmin = snowflake.securityadmin
    snowflake.sysadmin      = snowflake.sysadmin
  }

  depends_on = [
    snowflake_database.databases,
    snowflake_role.roles,
    snowflake_user.users,
    snowflake_warehouse.warehouses,
  ]

  spec_file_path = "spec.yml"
}
```

The Snowflake Terraform provider uses private key authentication so this must be setup before you are able to deploy resources to the Snowflake account. More information on setting up a private key pair for Snowflake can be found here: https://docs.snowflake.com/en/user-guide/key-pair-auth.html

The following is an example of a working `providers.tf` file to be used in the root module:

```hcl
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.46.0"
    }
  }
}

provider "snowflake" {
  account                = var.snowflake_account
  username               = var.snowflake_username
  private_key_path       = var.snowflake_private_key_path
  private_key_passphrase = var.snowflake_private_key_passphrase
  role                   = var.snowflake_role
}

provider "snowflake" {
  alias                  = "useradmin"
  account                = var.snowflake_account
  username               = var.snowflake_username
  private_key_path       = var.snowflake_private_key_path
  private_key_passphrase = var.snowflake_private_key_passphrase
  role                   = "USERADMIN"
}

provider "snowflake" {
  alias                  = "securityadmin"
  account                = var.snowflake_account
  username               = var.snowflake_username
  private_key_path       = var.snowflake_private_key_path
  private_key_passphrase = var.snowflake_private_key_passphrase
  role                   = "SECURITYADMIN"
}

provider "snowflake" {
  alias                  = "sysadmin"
  account                = var.snowflake_account
  username               = var.snowflake_username
  private_key_path       = var.snowflake_private_key_path
  private_key_passphrase = var.snowflake_private_key_passphrase
  role                   = "SYSADMIN"
}
```

### Configuring Resources

The YAML specification file is used to define the relative permissions between databases, roles, users and warehouses in a Snowflake account.

Database permissions are abbreviated as `read` or `write` permissions, with this module generating the proper grants. The following table shows the association between this module's permissions and Snowflake grants.

|  Objects   | Permissions | Snowflake Grants                             |
|------------|-------------|----------------------------------------------|
| Databases  | read        | USAGE                                        |
|            | write       | MONITOR, CREATE SCHEMA                       |
| Schemas    | read        | USAGE                                        |
|            | write       | MONITOR, CREATE TABLE, CREATE VIEW, CREATE STAGE, CREATE FILE FORMAT, CREATE SEQUENCE, CREATE FUNCTION, CREATE PIPE                                 |
| Tables     | read        | SELECT                                       |
|            | write       | INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES |
| Warehouses |             | USAGE, OPERATE, MONITOR                      |

For `schemas` and `tables`, if no permission is specified, then the permissions specified for the database are assumed. The `warehouse` objects have a single permission type so they are specified without a `read` or `write` qualifier (see below).

#### spec.yml

An RBAC specification file has the following structure:

```yaml
databases:
  database_name:
    privileges:
      database:
        read:
          roles:
            - role_name
            - ...
        write:
          roles:
            - role_name
            - ...
      schemas:
        read:
          roles:
            - role_name
            - ...
        write:
          roles:
            - role_name
            - ...
      tables:
        read:
          roles:
            - role_name
            - ...
        write:
          roles:
            - role_name
            - ...
  ... ... ...

roles:
  role_name:
    grant_to:
      roles:
        - role_name
        - ...
      users:
        - user_name
        - ...
  ... ... ...

warehouses:
  warehouse_name:
    privileges:
      roles:
        - role_name
        - ...
  ... ... ...
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | >= 0.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake.useradmin"></a> [snowflake.useradmin](#provider\_snowflake.useradmin) | 0.46.0 |
| <a name="provider_snowflake.securityadmin"></a> [snowflake.securityadmin](#provider\_snowflake.securityadmin) | 0.46.0 |
| <a name="provider_snowflake.sysadmin"></a> [snowflake.sysadmin](#provider\_snowflake.sysadmin) | 0.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [snowflake_database_grant.database_read_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database_grant) | resource |
| [snowflake_database_grant.database_write_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database_grant) | resource |
| [snowflake_role_grants.role_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/role_grants) | resource |
| [snowflake_role_grants.user_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/role_grants) | resource |
| [snowflake_schema_grant.schema_read_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/schema_grant) | resource |
| [snowflake_schema_grant.schema_write_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/schema_grant) | resource |
| [snowflake_table_grant.table_read_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/table_grant) | resource |
| [snowflake_table_grant.table_write_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/table_grant) | resource |
| [snowflake_warehouse_grant.warehouse_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/warehouse_grant) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_spec_file_path"></a> [spec\_file\_path](#input\_spec\_file\_path) | The path to the RBAC specification file. | `string` | n/a | yes |

## Outputs

No outputs.
