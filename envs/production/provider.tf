provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_version = ">= 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
  }
  cloud {
    organization = "wakame"

    workspaces {
      name = "aws-cronjob"
    }
  }
}
