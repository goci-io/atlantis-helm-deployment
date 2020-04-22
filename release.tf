data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "atlantis" {
  name          = local.release_name
  namespace     = var.k8s_namespace
  version       = var.helm_release_version
  repository    = data.helm_repository.stable.metadata[0].name
  chart         = "atlantis"
  recreate_pods = true
  wait          = true

  values = [
    templatefile("${path.module}/defaults.yaml", {
      repos              = var.repositories
      organization       = var.organization
      vc_host            = var.vc_host
      namespace          = var.namespace
      name               = var.name
      stage              = var.stage
      region             = var.region
      tls_secret         = var.deploy_cert_manager_certificate ? format("%s-tls", local.release_name) : ""
      ingress_class      = var.ingress_class
      atlantis_url       = local.atlantis_url
      pod_annotations    = var.pod_annotations
      apply_requirements = join(",", var.apply_requirements)
    }),
    file("${var.helm_values_root}/values.yaml"),
  ]

  set {
    name  = format("%s.%s", var.vc_type, local.host_attribute[var.vc_type])
    value = var.vc_host
  }

  dynamic "set_sensitive" {
    for_each = ["user", "token", "secret"]

    content {
      name  = format("%s.%s", var.vc_type, set_sensitive.value)
      value = local.sensitives[set_sensitive.value]
    }
  }

  dynamic "set" {
    for_each = local.environment_variables

    content {
      name  = format("environment.%s", upper(set.key))
      value = set.value
    }
  }
}
