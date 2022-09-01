terraform {
  //For cloud configuration
  cloud {
    organization = "dustinliu"

    workspaces {
      name  = "dev1"
    }
  }
  //version requirements for terraform and provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.28.0"
    }
  }
  required_version = ">= 1.2.8"
}