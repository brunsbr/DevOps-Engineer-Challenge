# Project Variables
# This file defines the variables used in the Terraform configuration for the DevOps Engineer Challenge.
# it includes AWS region, image tag, application name, Fargate CPU and memory settings.

variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  type        = string
  default     = "eu-central-1"
}

variable "image_tag" {
  description = "Docker image tag to deploy from ECR"
  type        = string
  default     = "latest"
}

variable "app_name" {
  description = "Application name prefix"
  type        = string
  default     = "aspnet-core-api"
}

variable "fargate_cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 256
}

variable "fargate_memory" {
  description = "Fargate task memory in MiB."
  type        = number
  default     = 512
}