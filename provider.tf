terraform {
  required_version = ">= 0.12.1"

  required_providers {
    helm  = "~> 0.10"
  }
}

provider "aws" {
  version = "~> 2.45"
  region  = var.aws_region
}
