output "bucket_name" {
  value = module.prompt_storage_s3.s3_bucket_id
}

output "bucket_arn" {
  value = module.prompt_storage_s3.s3_bucket_arn
}
