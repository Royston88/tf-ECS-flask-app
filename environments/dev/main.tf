locals {
  prefix = "royston"
}

resource "aws_ecr_repository" "ecr" {
  name         = var.ecr_repository_name
  force_delete = true
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.9.0"

  cluster_name = var.cluster_name
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    var.taskdef_name = { 
      cpu    = 512
      memory = 1024
      container_definitions = {
        var.container_name = {
          essential = true
          image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.prefix}-ecr:latest"
          port_mappings = [
            {
              containerPort = 8080
              protocol      = "tcp"
            }
          ]
        }
      }
      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                   = data.aws_subnets.public.ids
      security_group_ids           = [aws_security_group.application_sg.id]
    }
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*"]
  }
}

resource "aws_security_group" "application_sg" {
  name        = "application_sg"
  description = "Allow 8080 to application"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_8080"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
