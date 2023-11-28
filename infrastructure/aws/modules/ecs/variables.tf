
variable "security_groups" {
  description = "List of security group IDs to associate with the ECS service"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs for the ECS task placement"
  type        = list(string)
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the IAM role that the ECS tasks will assume"
  type        = string
}

variable "image" {
  description = "Image in ECR"
  type        = string
}

variable "cpu" {
  description = "The number of CPU units used by the task."
  type        = number
  default     = "256"
}

variable "memory" {
  description = "The amount of memory (in MiB) used by the task."
  type        = number
  default     = "512"
}

variable "container_port" {
  description = "The port on the container to bind to."
  type        = number
  default     = 8000
}

variable "host_port" {
  description = "The port on the host to bind to."
  type        = number
  default     = 8000
}

variable "lb_tg_arn" {
  description = "Load balancer ARN"
  type        = string
}



