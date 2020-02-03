
locals {
  host_attribute = {
    github    = "hostname"
    gitlab    = "hostname"
    bitbucket = "baseURL"
  }

  repos_config = templatefile("${path.module}/config/server.yaml", {
    repos              = var.repositories
    organization       = var.organization
    vc_host            = var.vc_host
    namespace          = var.namespace
    stage              = var.stage
    region             = var.region
    apply_requirements = join(",", var.apply_requirements)
  })
}
