terraform {
  backend "s3" {
    bucket = "levio-aws-demo-fev-terraform"
    key    = "states/estamps-dev.tfstate"
    region = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "lambda_storage" {
  bucket = "${var.project_name}-lambda-storage"
}

module "template_storage" {
  source       = "../../modules/storage"
  environment  = var.environment
  project_name = var.project_name
}

module "dynamo_index" {
  source      = "../../modules/index"
  environment = var.environment
}

module "lambdas" {
  source                = "../../modules/lambdas"
  lambda_storage_bucket = aws_s3_bucket.lambda_storage.bucket
  template_storage = {
    bucket = module.template_storage.bucket_name,
    arn    = module.template_storage.bucket_arn,
  }
  template_dynamo_table = {
    name = module.dynamo_index.table_name,
    arn  = module.dynamo_index.table_arn,
  }
  project_name = var.project_name
  environment  = var.environment
}
