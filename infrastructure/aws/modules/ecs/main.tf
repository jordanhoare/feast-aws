# infrastructure/aws/modules/ecs/main.tf
resource "aws_ecs_cluster" "ecs" {
  name = "app_cluster"
}

resource "aws_ecs_service" "service" {
  name = "app_service"
  cluster                = aws_ecs_cluster.ecs.arn
  launch_type            = "FARGATE"
  enable_execute_command = true

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  task_definition                    = aws_ecs_task_definition.td.arn

  network_configuration {
    assign_public_ip = true
    security_groups  = var.security_groups
    subnets          = var.subnets
  }
}

resource "aws_ecs_task_definition" "td" {
  container_definitions = jsonencode([
    {
      name         = "app"
      image        = var.image
      cpu          = var.cpu
      memory       = var.memory
      essential    = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
    }
  ])
  family                   = "app"
  requires_compatibilities = ["FARGATE"]

  cpu                = var.cpu
  memory             = var.memory
  network_mode       = "awsvpc"
  task_role_arn      = var.ecs_task_execution_role_arn
  execution_role_arn = var.ecs_task_execution_role_arn
}
