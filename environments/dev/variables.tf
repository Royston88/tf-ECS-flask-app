variable "ecr_repository_name" {
  description = "ECR Repository Name"
  type        = string
}

variable "container_name" {
  description = "Container Name"
  type        = string
}

variable "cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}

variable "taskdef_name" {
  description = "Task Definition Name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS Service Name"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}