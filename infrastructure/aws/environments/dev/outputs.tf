output "project_name" {
  value = var.project_name
}

output "project_bucket" {
  value = "s3://${module.feast_s3_bucket.bucket_name}"
}
