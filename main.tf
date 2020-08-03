locals {
  host_attribute = {
    github    = "hostname"
    gitlab    = "hostname"
    bitbucket = "baseURL"
  }

  release_name = length(var.attributes) > 0 ? format("%s-%s", var.name, join("-", var.attributes)) : var.name
  atlantis_url = format("%s.%s", local.release_name, var.cluster_fqdn)

  environment_variables = merge({
    namespace          = var.namespace
    aws_default_region = var.aws_region
    tf_bucket          = module.state_backend.s3_bucket_id
  }, var.environment_variables)
}
