terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.5.0"
    }
  }
  backend "s3" {}
}

# ACM requires us-east-1
provider "aws" {
  region              = "us-east-1"
  alias               = "us-east-1"
  allowed_account_ids = var.allowed_account_ids

  default_tags {
    tags = {
      Environment = "${var.app}-${var.env}"
    }
  }
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = var.allowed_account_ids

  default_tags {
    tags = {
      Environment = "${var.app}-${var.env}"
    }
  }
}
