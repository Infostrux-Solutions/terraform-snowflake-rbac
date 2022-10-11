# terraform-snowflake-rbac

Quickly deploy Snowflake RBAC resources using a simple configuration model.

This module assumes the resources specified have been created in Snowflake by other means (e.g. through the Snowflake UI, using DDL commands or another Terraform project). In other words, no resources are created using this module, instead, they are associated using their respective `snowflake_*_grant` Terraform resource blocks.

## Usage

```hcl
module "rbac" {
  source  = "Infostrux-Solutions/rbac/snowflake"
  version = "1.0.0"

  providers = {
    snowflake = snowflake.securityadmin
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

### Snowflake Role

Snowflake recommends using the **SECURITYADMIN** system role to grant or revoke privileges on objects in the account. Though not required, this module should be configured with a provider alias that uses **SECURITYADMIN** to deploy the resource grants.

The following is an example of a working `providers.tf` file which specifies a user-configurable role (default) and the **SECURITYADMIN** aliased role:

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
  alias                  = "securityadmin"
  account                = var.snowflake_account
  username               = var.snowflake_username
  private_key_path       = var.snowflake_private_key_path
  private_key_passphrase = var.snowflake_private_key_passphrase
  role                   = "SECURITYADMIN"
}
```

### Configuring Resources

The YAML specification file defines the relative permissions between databases, roles, users and warehouses in a Snowflake account.

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

If no permission is specified for `schemas` and `tables`, then the permissions set for the database are assumed. The `warehouse` objects have a single permission type, so they are specified without a `read` or `write` qualifier (see below).

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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | >= 0.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | >= 0.46.0 |

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
<!-- END_TF_DOCS -->

## Authors
Module is maintained by [Infostrux Solutions](mailto:opensource@infostrux.com) with help from [these awesome contributors](https://github.com/Infostrux-Solutions/terraform-snowflake-rbac/graphs/contributors).

## License
Apache 2 Licensed. See [LICENSE](https://github.com/Infostrux-Solutions/terraform-snowflake-rbac/blob/main/LICENSE) for full details.
