locals {
  bucket_access = [
    {
      actions = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
      resources = [
        module.state_backend.s3_bucket_arn,
        format("%s/*", module.state_backend.s3_bucket_arn),
      ]
    },
    {
      actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
      resources = [module.state_backend.dynamodb_table_arn]
    }
  ]

  policy_statements = concat(local.bucket_access, var.server_role_policy_statements)

  role_annotation        = module.iam_role.role_arn != "" || var.server_role_arn != "" ? coalesce(module.iam_role.role_arn, var.server_role_arn) : ""
  external_id_annotation = module.iam_role.external_id != "" || var.server_role_external_id != "" ? coalesce(module.iam_role.external_id, var.server_role_external_id) : ""

  kiam_annotations = local.role_annotation == "" ? {} : {
    "iam.amazonaws.com/role"        = coalesce(module.iam_role.role_arn, var.server_role_arn)
    "iam.amazonaws.com/external-id" = local.external_id_annotation
  }
}

module "iam_role" {
  source            = "git::https://github.com/goci-io/aws-iam-assumable-role.git?ref=tags/0.1.1"
  enabled           = var.create_server_role
  namespace         = var.namespace
  stage             = var.stage
  attributes        = [var.region]
  name              = local.release_name
  policy_statements = local.policy_statements
  trusted_iam_arns  = var.server_role_trusted_arns
}
