terraform {
  required_version = ">= 1.0.0"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.44.0"
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
