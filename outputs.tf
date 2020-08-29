output "atlantis_domain" {
  value = local.atlantis_url
}

output "release_name" {
  value = local.release_name
}

output "iam_role_arn" {
  value = local.role_annotation
}

output "s3_state_bucket_id" {
  value = module.state_backend.s3_bucket_id
}

output "s3_state_bucket_arn" {
  value = module.state_backend.s3_bucket_arn
}

output "dynamodb_lock_table_arn" {
  value = module.state_backend.dynamodb_table_arn
}
