terraform {
  backend "s3" {
    region         = "ap-southeast-2"
    key            = "terraform.tfstate"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

module "feast_s3_bucket" {
  source      = "./../../modules/s3"
  project_name = var.project_name
}

resource "aws_s3_object" "driver_stats_upload" {
  bucket = module.feast_s3_bucket.bucket_name
  key    = "driver_stats.parquet"
  source = "${path.module}/../../../../data/driver_stats.parquet"
}
