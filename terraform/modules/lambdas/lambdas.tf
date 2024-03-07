locals {
  runtime = "python3.11"
}

module "get_templates" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.project_name}-get-templates-${var.environment}"
  handler       = "index.lambda_handler"
  runtime       = local.runtime
  publish       = true

  source_path = "${path.module}/get_templates/src"

  store_on_s3 = true
  s3_bucket   = var.lambda_storage_bucket

  layers = [module.lambda_layer_s3.lambda_layer_arn]

  environment_variables = {
    DYNAMO_TABLE = var.template_dynamo_table.name
    S3_BUCKET    = var.template_storage.bucket
  }
  attach_policy_statements = true
  policy_statements = {
    s3 = {
      effect = "Allow"
      actions = [
        "s3:GetObject",
      ]
      resources = [
        var.template_storage.arn,
      ]
    }
    dynamodb = {
      effect = "Allow"
      actions = [
        "dynamodb:Scan",
      ]
      resources = [
        var.template_dynamo_table.arn,
      ]
    }
  }
}

module "delete_template" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.project_name}-delete-template-${var.environment}"
  handler       = "index.lambda_handler"
  runtime       = local.runtime
  publish       = true

  source_path = "${path.module}/delete_template/src"

  store_on_s3 = true
  s3_bucket   = var.lambda_storage_bucket

  layers = [module.lambda_layer_s3.lambda_layer_arn]

  environment_variables = {
    DYNAMO_TABLE = var.template_dynamo_table.name
    S3_BUCKET    = var.template_storage.bucket
  }

  attach_policy_statements = true
  policy_statements = {
    s3 = {
      effect = "Allow"
      actions = [
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
      ]
      resources = [
        var.template_storage.arn,
      ]
    }
    dynamodb = {
      effect = "Allow"
      actions = [
        "dynamodb:DeleteItem",
      ]
      resources = [
        var.template_dynamo_table.arn,
      ]
    }
  }
}

module "post_template" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.project_name}-post-template-${var.environment}"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = local.runtime
  publish       = true

  source_path = "${path.module}/post_template/src"

  store_on_s3 = true
  s3_bucket   = var.lambda_storage_bucket

  layers = [module.lambda_layer_s3.lambda_layer_arn]

  environment_variables = {
    DYNAMO_TABLE = var.template_dynamo_table.name
    S3_BUCKET    = var.template_storage.bucket
  }

  attach_policy_statements = true
  policy_statements = {
    s3 = {
      effect = "Allow"
      actions = [
        "s3:PutObject",
        "s3:GetObject",
      ]
      resources = [
        var.template_storage.arn,
      ]
    }
  }
}

module "lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "${var.project_name}-prompt-template-layer-${var.environment}"
  description         = "Layer that has the template pydantic class library (deployed from S3)"
  compatible_runtimes = [local.runtime]

  source_path = "${path.module}/layer/src"

  store_on_s3 = true
  s3_bucket   = var.lambda_storage_bucket
}
