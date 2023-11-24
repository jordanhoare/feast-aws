variable "bucket_name" {
  description = "The name of the S3 bucket to be created for storing Terraform state files."
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to be created for state locking."
  type        = string
}