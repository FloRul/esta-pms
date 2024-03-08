module "template_index_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "prompt-index-${var.environment}"
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "S"
    },
  ]
}