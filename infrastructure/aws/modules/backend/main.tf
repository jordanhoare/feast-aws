terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_string" "bucket_suffix" {
  length  = 6 
  special = false
  upper   = false
  numeric  = true
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket_name}-${random_string.bucket_suffix.result}"

  # lifecycle {
  #     prevent_destroy = true
  #   }

  tags = {
    Name        = "terraform_state"
    Environment = "dev"
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name            = "${var.dynamodb_table_name}-${random_string.bucket_suffix.result}"
  hash_key        = "LockID"
  read_capacity   = 20
  write_capacity  = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform_state"
    Environment = "dev"
  }
}