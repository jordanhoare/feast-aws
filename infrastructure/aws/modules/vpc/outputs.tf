# infrastructure/aws/modules/vpc/outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "security_group_ids" {
  description = "List of security group IDs"
  value       = aws_security_group.sg[*].id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = [aws_subnet.sn1.id, aws_subnet.sn2.id, aws_subnet.sn3.id]
}
