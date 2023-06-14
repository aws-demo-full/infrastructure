variable "project_name" {
  description = "Project name."
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  default = "eu-central-1"
}

variable "domain" {
  description = "Project domain."
}

variable "frontend_bucket" {
  description = "The AWS S3 frontend bucket name."
}