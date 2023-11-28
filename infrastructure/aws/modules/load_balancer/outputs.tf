# infrastructure/aws/modules/load_balancer/outputs.tf

output "lb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.alb.arn
}

output "http_listener_arn" {
  description = "The ARN of the HTTP listener"
  value       = aws_lb_listener.http_listener.arn
}

output "lb_tg_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.lb_tg.arn
}
