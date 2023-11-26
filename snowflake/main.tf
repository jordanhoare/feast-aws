terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "0.76.0"
    }
  }
}

provider "aws" {
  region   = "ap-southeast-2"
}

provider "snowflake" {
  account  = var.SNOWFLAKE_ACCOUNT
  user = var.SNOWFLAKE_USERNAME
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

