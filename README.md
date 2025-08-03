# DevOps Engineer Challenge — Zero-Downtime Deployment (.NET + ECS Fargate)

# Overview:

This challenge/project demonstrates a Zero-downtime deployment strategy for an ASP.NET Core 8 Web API using:

- AWS ECS Fargate with Blue-Green deployment
- Application Load Balancer (ALB) with dual Target Groups
- Azure DevOps Pipelines for CI/CD orchestration
- Terraform for Infrastructure as Code (IaC)
- Automated Health Checks and Rollback

# Architecture:

- Two ECS services: `blue` and `green`, pointing to their own Target Groups.
- ALB routes traffic to the active version.
- Health check system decides whether to switch or rollback.
- Docker image built and pushed to ECR.
- Deploy and switch managed by Azure DevOps + Terraform.

# Technologies Used:

- ASP.NET Core 8 Web API
- Docker & Amazon ECR
- AWS ECS Fargate
- Application Load Balancer (ALB)
- Route 53 (optional)
- Terraform
- Azure DevOps (Free Tier)
- Shell scripts (health check, traffic switch)

# CI/CD Pipeline Structure:

| Stage            | Description                                   |
|------------------|-----------------------------------------------|
| `Build`          | Builds and tests the .NET application         |
| `Docker`         | Builds and pushes Docker image to ECR         |
| `DeployGreen`    | Deploys the new version to the GREEN service  |
| `HealthCheck`    | Verifies if the GREEN version is healthy      |
| `SwitchTraffic`  | Switches ALB traffic to GREEN (if healthy)    |
| `Rollback`       | Rolls back to BLUE if GREEN fails health check|

#	Variables & Parameters:

| Variable         | Description                              |
|------------------|------------------------------------------|
| `image_tag`      | Docker tag used to identify deployment   |
| `aws_region`     | AWS region used (default: `eu-central-1`)   |
| `hosted_zone_id` | (Optional) Route 53 zone for DNS routing |

#	Success Criteria:

- [x] Blue-Green deployment with ECS Fargate
- [x] Zero-downtime deploy via ALB Target Group switch
- [x] Health check validation (`/health`)
- [x] Automated rollback within 60 seconds
- [x] Pipeline documentation and full automation
- [ ] Load testing (optional)

# Running the Deployment:

```bash
# Manual apply with image tag
cd infra
terraform apply -auto-approve -var="image_tag=build-XxX"
```

# Source of research:

| Site             | Link                         |
|------------------|------------------------------|
| `Microsoft`      | https://tinyurl.com/48cnjppb |
| `Medium`         | https://tinyurl.com/5csvswh7 |
| `Amazon`         | https://tinyurl.com/n94br69x |
| `AWS Regions`    | https://tinyurl.com/2x3mfnsh |
| `Medium`         | https://tinyurl.com/ycxkyxwk |
| `Terraform`      | https://tinyurl.com/4sjdnr33 |



