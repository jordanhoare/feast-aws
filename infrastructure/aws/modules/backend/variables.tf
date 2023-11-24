variable "region" {
  description = "Region for AWS resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "bucket_name" {
  description = "The name of the S3 bucket to be created for storing Terraform state files."
  default     = "terraform-state-storage"
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to be created for state locking."
  default     = "terraform-state-lock"
  type        = string
}
