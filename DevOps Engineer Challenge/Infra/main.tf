# Providers, ECR and general settings
# This file sets up the AWS provider, ECR repository, and general Terraform settings.
# Providers, ECR and general settings

provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

resource "aws_ecr_repository" "app" {
  name = "aspnet-core-api"
}