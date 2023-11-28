# infrastructure/aws/modules/load_balancer/variables.tf

variable "lb_name" {
  description = "The name of the load balancer"
  type        = string
}

variable "tg_name" {
  description = "The name of the target group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the load balancer and target group are deployed"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to attach to the load balancer"
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs to attach to the load balancer"
  type        = list(string)
}
