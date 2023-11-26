terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "0.73.0" # 0.74+ are bad releases - https://github.com/Snowflake-Labs/terraform-provider-snowflake/issues/2131
    }
  }
}

provider "aws" {
  region   = "ap-southeast-2"
}

provider "snowflake" {
  account  = var.SNOWFLAKE_ACCOUNT
  username = var.SNOWFLAKE_USERNAME
  password = var.SNOWFLAKE_PASSWORD
  role = var.SNOWFLAKE_ROLE
}

provider "snowflake" {
  alias = "SYSADMIN"
  role = "SYSADMIN"
}

provider "snowflake" {
  alias = "SECURITYADMIN"
  role  = "SECURITYADMIN"
}

provider "snowflake" {
  alias = "ACCOUNTADMIN"
  role  = "ACCOUNTADMIN"
}

