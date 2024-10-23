locals {
  domain = (var.env == "prd") ? "rll.byu.edu" : "rll-dev.byu.edu"
  url    = lower("${var.project_name}.${local.domain}")
  apiUrl = "api.${local.url}"
}

module "acs" {
  source = "github.com/byu-oit/terraform-aws-acs-info?ref=v4.0.0"
}

# ========== S3 Static Site ==========
data "aws_route53_zone" "domain_zone" {
  name = local.domain
}

module "s3_site" {
  source         = "github.com/byu-oit/terraform-aws-s3staticsite?ref=v7.0.2"
  site_url       = local.url
  hosted_zone_id = data.aws_route53_zone.domain_zone.id
  s3_bucket_name = "${var.app_name}-${var.env}"
}

# ========== API ==========
module "lambda_api" {
  source = "github.com/byuawsfhtl/terraform-lambda-api?ref=prd"

  project_name                 = var.project_name
  app_name                     = var.app_name
  domain                       = local.domain
  url                          = local.url
  api_url                      = local.apiUrl
  ecr_repo                     = var.ecr_repo
  image_tag                    = var.image_tag
  lambda_endpoint_definitions  = var.lambda_endpoint_definitions
  lambda_environment_variables = var.lambda_environment_variables
  function_policies            = var.lambda_policies
}
