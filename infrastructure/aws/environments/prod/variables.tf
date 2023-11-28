variable "profile" {
  description = "AWS Profile"
  type        = string
  default     = "terraform"
}

variable "region" {
  description = "Region for AWS resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  type        = string
  description = "The project identifier is used to uniquely namespace resources"
  default     = "sandbox"
}
