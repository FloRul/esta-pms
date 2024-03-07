module "prompt_storage_s3" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.project_name}-storage-${var.environment}"
  acl    = "private"

  versioning = {
    enabled = true
  }
}