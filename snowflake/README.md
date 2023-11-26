Main Configuration Files:
feast.tf: Defines a service account user, a Snowflake role (FEAST_admin), and modules for a database (database-FEAST) and a warehouse (warehouse-FEAST_WH).
main.tf: Sets up the required providers, including Snowflake and AWS, and configures multiple Snowflake providers with different roles.

Modules:
Database Module (/modules/database/):
grants.tf: Manages grants for databases, schemas, tables, and views.
main.tf: Creates a Snowflake database.
variables.tf: Defines variables for the database module.
Service Account Module (/modules/service-account/):
main.tf: Creates a Snowflake user and manages AWS secrets.
variables.tf: Defines variables for the service account module.
Warehouse Module (/modules/warehouse/):
grants.tf: Manages grants for a Snowflake warehouse.
main.tf: Creates a Snowflake warehouse and resource monitor.
variables.tf: Defines variables for the warehouse module.
Workspace Module (/modules/workspace/):
database.tf: Manages a Snowflake database and grants within the workspace.
roles.tf, user.tf: Define roles and users within the workspace.