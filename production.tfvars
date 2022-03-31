env                     = "production"
allowed_account_ids     = ["524123680587"]
root_domain             = "saturn.network"
static_assets_bucket    = "filecoin-saturn"

# rds
database_alpha_cidr     = "10.100.48.0/24"
database_bravo_cidr     = "10.100.112.0/24"
database_charlie_cidr   = "10.100.176.0/24"
deletion_protection     = true
backup_retention_period = 7
rds_instance_class      = "db.r4.xlarge"

# CIDR range based off this guide
# https://aws.amazon.com/blogs/startups/practical-vpc-design/
vpc_cidr                = "10.100.0.0/16"

private_alpha_cidr      = "10.100.0.0/19"
public_alpha_cidr       = "10.100.32.0/20"
#spare_alpha_cidr       = "10.100.48.0/20"

private_bravo_cidr      = "10.100.64.0/19"
public_bravo_cidr       = "10.100.96.0/20"
#spare_bravo_cidr       = "10.100.112.0/20"

private_charlie_cidr    = "10.100.128.0/19"
public_charlie_cidr     = "10.100.160.0/20"
#spare_charlie_cidr     = "10.100.176.0/20"

#spare_cidr             = "10.100.192.0/18"
