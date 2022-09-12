# terraform-snowflake-X
Quickly deploy Snowflake resources using a simple configuration model.

## Usage

Copy the `terraform.tfvars.example` file to `terraform.tfvars` and populate it with your desired Snowflake environment. For example,

```hcl
environments = [
  "DEV",
  "PROD",
]
data_stages = [
  "INGEST",
  "CLEAN",
  "NORMALIZE",
  "INTEGRATE",
  "ANALYZE",
]
user_grants = {
  "DBT_CLOUD" = ["CICD"]
}
role_grants = {
  "DBA"       = ["CICD"]
  "CICD"      = ["ETL", "DEVELOPER"]
  "ETL"       = ["INGEST_RW"]
  "DEVELOPER" = ["INGEST_R", "CLEAN_RW", "CLEAN_R", "NORMALIZE_RW", "INTEGRATE_RW", "ANALYST"]
  "ANALYST"   = ["ANALYZE_RW", "REGUSER"]
  "REGUSER"   = ["NORMALIZE_R", "INTEGRATE_R", "ANALYZE_R"]
}
```

The module will iterate through the configuration and determine which resources will be created. For example, by specifying multiple environments, the data stages and associated roles will be created for each environment. You can also leave the `environments` list empty to keep your environment simple (a single instance of each stage is created with no prefix).

The users and roles created are inferred from the grant mapping by walking the configuration and ensuring all of the resources are created to successfully deploy the desired state.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | 0.43.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake.securityadmin"></a> [snowflake.securityadmin](#provider\_snowflake.securityadmin) | 0.43.0 |
| <a name="provider_snowflake.sysadmin"></a> [snowflake.sysadmin](#provider\_snowflake.sysadmin) | 0.43.0 |
| <a name="provider_snowflake.useradmin"></a> [snowflake.useradmin](#provider\_snowflake.useradmin) | 0.43.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [snowflake_database.databases](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/database) | resource |
| [snowflake_database_grant.database_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/database_grant) | resource |
| [snowflake_role.roles](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/role) | resource |
| [snowflake_role_grants.role_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/role_grants) | resource |
| [snowflake_role_grants.user_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/role_grants) | resource |
| [snowflake_schema_grant.schema_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/schema_grant) | resource |
| [snowflake_table_grant.table_grants_r](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/table_grant) | resource |
| [snowflake_table_grant.table_grants_rw](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/table_grant) | resource |
| [snowflake_user.users](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_stages"></a> [data\_stages](#input\_data\_stages) | The list of data stages to create in the Snowflake account. | `list(string)` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | The list of environments to create in the Snowflake account. | `list(string)` | n/a | yes |
| <a name="input_role_grants"></a> [role\_grants](#input\_role\_grants) | A map of roles and which role they are granted to. | `map(list(string))` | n/a | yes |
| <a name="input_snowflake_account"></a> [snowflake\_account](#input\_snowflake\_account) | The Snowflake account that we will be deploying into. | `string` | n/a | yes |
| <a name="input_snowflake_private_key_passphrase"></a> [snowflake\_private\_key\_passphrase](#input\_snowflake\_private\_key\_passphrase) | The passphrase for the private key used to authenticate the Snowflake user. | `string` | n/a | yes |
| <a name="input_snowflake_private_key_path"></a> [snowflake\_private\_key\_path](#input\_snowflake\_private\_key\_path) | The path to the private key used to authenticate the Snowflake user. | `string` | n/a | yes |
| <a name="input_snowflake_role"></a> [snowflake\_role](#input\_snowflake\_role) | The Snowflake role used to deploy into the Snowflake account. | `string` | n/a | yes |
| <a name="input_snowflake_username"></a> [snowflake\_username](#input\_snowflake\_username) | The name of the Snowflake user used to deploy into the Snowflake account. | `string` | n/a | yes |
| <a name="input_user_grants"></a> [user\_grants](#input\_user\_grants) | A map of users and which role they are granted to. | `map(list(string))` | n/a | yes |

## Outputs

No outputs.
