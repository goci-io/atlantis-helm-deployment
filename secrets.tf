data "aws_ssm_parameter" "user" {
  count = var.ssm_parameter_user == "" ? 0 : 1
  name  = var.ssm_parameter_user
}

data "aws_ssm_parameter" "token" {
  count = var.ssm_parameter_token == "" ? 0 : 1
  name  = var.ssm_parameter_token
}

data "aws_ssm_parameter" "secret" {
  count = var.ssm_parameter_secret == "" ? 0 : 1
  name  = var.ssm_parameter_secret
}

data "aws_lambda_invocation" "decrypt" {
  count         = var.lambda_encryption_function == "" ? 0 : 1
  function_name = var.lambda_encryption_function

  input = jsonencode({
    map = {
      user   = var.encrypted_user
      token  = var.encrypted_token
      secret = var.encrypted_secret
    }
  })
}

locals {
  secret_keys            = keys(var.lambda_custom_secrets)
  secrets_name           = length(local.secret_keys) > 0 ? format("%s-custom", local.release_name) : ""
  decrypt_secrets_result = length(local.secret_keys) > 0 ? data.aws_lambda_invocation.decrypt_additional.0.result_map : {}
  decrypt_result         = data.aws_lambda_invocation.decrypt.*.result_map

  sensitives = {
    user   = join("", coalescelist(local.decrypt_result.*.user, data.aws_ssm_parameter.user.*.value, [var.encrypted_user]))
    token  = join("", coalescelist(local.decrypt_result.*.token, data.aws_ssm_parameter.token.*.value, [var.encrypted_token]))
    secret = join("", coalescelist(local.decrypt_result.*.secret, data.aws_ssm_parameter.secret.*.value, [var.encrypted_secret]))
  }
}

data "aws_lambda_invocation" "decrypt_additional" {
  count         = length(local.secret_keys) > 0 ? 1 : 0
  function_name = var.lambda_encryption_function

  input = jsonencode({
    map = var.lambda_custom_secrets
  })
}

resource "kubernetes_secret" "custom_secrets" {
  count = length(local.secret_keys) > 0 ? 1 : 0
  data  = local.decrypt_secrets_result

  metadata {
    name      = local.secrets_name
    namespace = var.k8s_namespace
  }
}
