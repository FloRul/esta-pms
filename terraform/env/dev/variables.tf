variable "environment" {
  description = "The environment to deploy to"
  type        = string
  nullable    = false
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  nullable    = false
}

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  nullable    = false
}