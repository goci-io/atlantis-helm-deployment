data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

locals {
  default_nginx_annotations = {
    "nginx.ingress.kubernetes.io/ssl-passthrough"    = "true",
    "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true",
  }

  cert_manager_issuer_type  = var.cert_manager_issuer_name == "" ? "cluster-issuer" : "issuer"
  cert_manager_issuer       = var.cert_manager_issuer_name == "" ? var.cert_manager_cluster_issuer_name : var.cert_manager_issuer_name
  cert_manager_annotations  = var.configure_cert_manager ? { "cert-manager.io/${local.cert_manager_issuer_type}" = local.cert_manager_issuer } : {}
  ingress_class_annotations = var.ingress_class == "" ? {} : { "kubernetes.io/ingress.class" = var.ingress_class }
  nginx_ingress_annotations = var.configure_nginx ? local.default_nginx_annotations : {}

  enable_tls          = var.configure_cert_manager || var.enable_tls
  ingress_annotations = merge({}, local.cert_manager_annotations, local.ingress_class_annotations, local.nginx_ingress_annotations)
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
      repos               = var.repositories
      organization        = var.organization
      vc_host             = var.vc_host
      namespace           = var.namespace
      stage               = var.stage
      region              = var.region
      release             = local.release_name
      terraform_env       = var.terraform_environment_variables
      atlantis_env_expose = var.exposed_atlantis_environment_variables
      tls_secret          = local.enable_tls ? format("%s-tls", local.release_name) : ""
      ingress_annotations = local.ingress_annotations
      atlantis_url        = local.atlantis_url
      pod_annotations     = var.pod_annotations
      apply_requirements  = join(",", var.apply_requirements)
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
