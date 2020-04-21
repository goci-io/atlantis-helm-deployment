terraform {
  required_version = ">= 0.12.1"

  required_providers {
    helm = "~> 1.0"
  }
}

provider "aws" {
  version = "~> 2.45"
  region  = var.aws_region

  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}
