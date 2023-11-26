locals {
  // TODO: no-op for now, see tags.tf
  FEAST = {
    tags = {
      pii = true
    }
  }
}

// service account user
module "service-account-FEAST_SA" {
  source = "./modules/service-account"
  providers = {
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name    = "FEAST_SA"
  comment = "Feast service account"
}


// role
resource "snowflake_role" "FEAST_admin" {
  provider = snowflake.SECURITYADMIN
  name     = "FEAST_ADMIN"
}

resource "snowflake_role_grants" "FEAST_admin" {
  provider  = snowflake.SECURITYADMIN
  role_name = snowflake_role.FEAST_admin.name

  roles = [
    "SYSADMIN",
  ]

  users = [module.service-account-FEAST_SA.name]
}

// database
module "database-FEAST" {
  source = "./modules/database"
  providers = {
    snowflake               = snowflake
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name         = "FEAST"
  admin_roles  = [snowflake_role.FEAST_admin.name]
  reader_roles = []
}

// warehouse + monitor
module "warehouse-FEAST_WH" {
  source = "./modules/warehouse"
  providers = {
    snowflake.ACCOUNTADMIN  = snowflake.ACCOUNTADMIN
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name            = "FEAST_WH"
  warehouse_roles = [snowflake_role.FEAST_admin.name]
}
