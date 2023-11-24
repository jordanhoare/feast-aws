resource "aws_s3_bucket" "feast_bucket" {
  bucket        = "feast-workshop-${var.project_name}"
  force_destroy = true
}
