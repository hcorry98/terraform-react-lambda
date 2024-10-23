locals {
  url = var.url == "" ? lower("${var.project_name}.com") : var.url
  domain = var.domain == "" ? local.url : var.domain
  api_url = var.api_url == "" ? "api.${local.url}" : var.api_url
}

# ========== S3 Static Site ==========
data "aws_route53_zone" "domain_zone" {
  name = local.domain
}

module "s3_site" {
  source         = "github.com/hcorry98/terraform-aws-s3staticsite?ref=prd"
  site_url       = local.url
  hosted_zone_id = data.aws_route53_zone.domain_zone.id
  s3_bucket_name = "${var.app_name}-${var.env}"
}

# ========== API ==========
module "lambda_api" {
  source = "github.com/hcorry98/terraform-lambda-api?ref=prd"

  project_name                 = var.project_name
  app_name                     = var.app_name
  domain                       = local.domain
  url                          = local.url
  api_url                      = var.apiUrl
  ecr_repo                     = var.ecr_repo
  image_tag                    = var.image_tag
  lambda_endpoint_definitions  = var.lambda_endpoint_definitions
  lambda_environment_variables = var.lambda_environment_variables
  function_policies            = var.lambda_policies
}
