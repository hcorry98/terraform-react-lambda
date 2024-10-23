variable "project_name" {
  type        = string
  description = "The name of the project in TitleCase."
}
variable "app_name" {
  type        = string
  description = "The name of the project in kebab-case."
}

variable "domain" {
  type        = string
  description = "The domain for the project."
  default     = ""
}
variable "url" {
  type        = string
  description = "The URL for the project."
  default     = ""
}
variable "api_url" {
  type        = string
  description = "The URL for the API."
  default     = ""
}

variable "env" {
  type        = string
  description = "The branch being deployed"
}

variable "ecr_repo" {
  type = object({
    name           = string,
    repository_url = string
  })
  description = "The ECR repository that contains the image for the lambda functions."
}
variable "image_tag" {
  type        = string
  description = "The image tag for the Docker image (the timestamp)."
}

variable "lambda_environment_variables" {
  type        = map(string)
  description = "The environment variables to set on the Lambda functions."
  default     = {}
}

variable "lambda_endpoint_definitions" {
  type = list(object({
    path_part       = string
    allowed_headers = optional(string)

    method_definitions = list(object({
      http_method = string
      command     = list(string)
      timeout     = optional(number)
    }))
  }))
  description = "The definitions for each lambda function."
}
variable "lambda_policies" {
  type        = list(string)
  description = "List of IAM Policy ARNs to attach to the task execution policy."
  default     = []
}
