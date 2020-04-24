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
  decrypt_result = data.aws_lambda_invocation.decrypt.*.result_map

  sensitives = {
    user   = join("", coalescelist(local.decrypt_result.*.user, data.aws_ssm_parameter.user.*.value, [var.encrypted_user]))
    token  = join("", coalescelist(local.decrypt_result.*.token, data.aws_ssm_parameter.token.*.value, [var.encrypted_token]))
    secret = join("", coalescelist(local.decrypt_result.*.secret, data.aws_ssm_parameter.secret.*.value, [var.encrypted_secret]))
  }
}
