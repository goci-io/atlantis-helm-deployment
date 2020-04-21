
locals {
  host_attribute = {
    github    = "hostname"
    gitlab    = "hostname"
    bitbucket = "baseURL"
  }

  environment_variables = merge({
    namespace = var.namespace
  }, var.environment_variables)
}
