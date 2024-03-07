module "template_index_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "prompt-index-${var.environment}"
  hash_key = "id"
  range_key = "version"

  attributes = [
    {
      name = "id"
      type = "N"
    },
    {
      name = "version"
      type = "S"
    }
  ]
}