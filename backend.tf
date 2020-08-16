module "state_backend" {
  source     = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=tags/0.18.2"
  region     = var.aws_region
  namespace  = var.namespace
  stage      = "atlantis"
  name       = "terraform"
  attributes = ["state", var.region]
}

output "state_backend_s3_bucket_arn" {
  value = module.state_backend.s3_bucket_arn
}

output "state_backend_dynamodb_table_arn" {
  value = module.state_backend.dynamodb_table_arn
}
