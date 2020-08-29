module "state_backend" {
  source     = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=tags/0.23.0"
  region     = var.aws_region
  namespace  = var.namespace
  stage      = var.stage
  name       = local.release_name
  attributes = ["terraform", "state", var.region]
}
