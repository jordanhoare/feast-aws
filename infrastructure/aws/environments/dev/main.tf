module "s3_backend" {
  source = "../modules/s3-backend"
  bucket_name         = "my-terraform-state-bucket"
  dynamodb_table_name = "my-terraform-state-lock"
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "path/to/my/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "my-terraform-state-lock"
    encrypt        = true
  }
}
