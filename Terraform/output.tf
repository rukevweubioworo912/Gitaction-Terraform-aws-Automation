output "ecr_repo_url" {
  value = aws_ecr_repository.app_repo.repository_url
}
output "ecr_repo_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.app_repo.arn
}
output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution IAM role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "load_balancer_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}

output "load_balancer_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app_lb.arn
}

output "target_group_arn" {
  description = "ARN of the Load Balancer target group"
  value       = aws_lb_target_group.app_tg.arn
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.app.arn
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
}