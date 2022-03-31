variable "env" {}

variable "app" {
  default = "saturn"
}

variable "allowed_account_ids" {
  type = list(string)
}

variable "aws_region" {
  default = "us-west-2"
}

variable "zones" {
  description = "AZ map by region"
  default = {
    us-west-2-alpha   = "us-west-2a"
    us-west-2-bravo   = "us-west-2b"
    us-west-2-charlie = "us-west-2c"
  }
}

variable "root_domain" {}

variable "static_assets_bucket" {}

variable "database_alpha_cidr" {}

variable "database_bravo_cidr" {}

variable "database_charlie_cidr" {}

variable "database_user" {}

variable "database_password" {}

variable "deletion_protection" {}

variable "backup_retention_period" {}

variable "rds_instance_class" {}

variable "vpc_cidr" {
  description = "CIDR block for base-app vpc"
}

variable "public_alpha_cidr" {
  description = "CIDR block for public subnet alpha"
}

variable "private_alpha_cidr" {
  description = "CIDR block for private subnet alpha"
}

variable "public_bravo_cidr" {
  description = "CIDR block for public subnet bravo"
}

variable "private_bravo_cidr" {
  description = "CIDR block for private subnet bravo"
}

variable "public_charlie_cidr" {
  description = "CIDR block for public subnet charlie"
}

variable "private_charlie_cidr" {
  description = "CIDR block for private subnet charlie"
}
