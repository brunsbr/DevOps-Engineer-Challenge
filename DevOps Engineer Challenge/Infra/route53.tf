# Optional
# Weight deactivated for simplicity, can be used for traffic shifting
# AWS Domain registered is necessary for Route53 to work properly
# An hosted zone created is required for this domain
# Route53 Configuration
# This file sets up Route53 records for the application.

variable "hosted_zone_id" {
  description = "Route53 ID of the Hosted Zone"
  type        = string
}

variable "domain_name" {
  description = "Subdomain to be used for the application"
  type        = string
  default     = "api.example.com"
}

# Register for BLUE version (weight 100%)
resource "aws_route53_record" "blue" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }

  set_identifier = "blue"
  #weight         = 100
  ttl            = 60
}

# Register for GREEN version (weight 0% initially)
resource "aws_route53_record" "green" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }

  set_identifier = "green"
  #weight         = 0
  ttl            = 60
}