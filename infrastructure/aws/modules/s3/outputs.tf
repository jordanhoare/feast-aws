# infrastructure\aws\modules\s3\outputs.tf

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.feast_bucket.bucket
}
