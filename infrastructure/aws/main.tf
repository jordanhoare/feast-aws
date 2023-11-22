provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "feast_bucket" {
  bucket        = "feast-workshop-${var.project_name}"
  force_destroy = true
}

resource "aws_s3_object" "driver_stats_upload" {
  bucket = aws_s3_bucket.feast_bucket.bucket
  key    = "driver_stats.parquet"
  source = "${path.module}/../../driver_stats.parquet"
}
