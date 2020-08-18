terraform {
  required_version = ">= 0.12.1"

  required_providers {
    aws        = "~> 2.50"
    helm       = "~> 1.0"
    random     = "~> 2.2"
    kubernetes = "~> 1.10"
  }
}
