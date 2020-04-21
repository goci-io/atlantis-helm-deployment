locals {
  certificate_content = templatefile("${path.module}/templates/certificates.yaml", {
    deploy_selfsigning_issuer = var.deploy_selfsigning_issuer
    issuer_kind               = var.cert_manager_issuer_kind
    issuer_name               = var.cert_manager_issuer_name
    dns_names                 = [local.atlantis_url]
    atlantis_url              = local.atlantis_url
    app_name                  = local.release_name
    k8s_namespace             = var.k8s_namespace
  })
}

resource "null_resource" "apply_certificate" {
  count = var.deploy_cert_manager_certificate ? 1 : 0

  provisioner "local-exec" {
    command = "echo \"${self.triggers.content}\" | kubectl apply -f -"
  }

  triggers = {
    content = local.certificate_content
  }
}

resource "null_resource" "destroy_certificate" {
  count = var.deploy_cert_manager_certificate ? 1 : 0

  provisioner "local-exec" {
    when    = destroy
    command = "echo \"${self.triggers.content}\" | kubectl delete -f -"
  }

  triggers = {
    content = local.certificate_content
  }
}
