env                     = "staging"
allowed_account_ids     = ["524123680587"]
root_domain             = "saturn-test.network"
static_assets_bucket    = "filecoin-saturn-staging"

# rds
database_alpha_cidr     = "10.10.48.0/24"
database_bravo_cidr     = "10.10.112.0/24"
database_charlie_cidr   = "10.10.176.0/24"
rds_instance_class      = "db.t3.medium"
deletion_protection     = false
backup_retention_period = 1

# CIDR range based off this guide
# https://aws.amazon.com/blogs/startups/practical-vpc-design/
vpc_cidr                = "10.10.0.0/16"

private_alpha_cidr      = "10.10.0.0/19"
public_alpha_cidr       = "10.10.32.0/20"
#spare_alpha_cidr       = "10.10.48.0/20"

private_bravo_cidr      = "10.10.64.0/19"
public_bravo_cidr       = "10.10.96.0/20"
#spare_bravo_cidr       = "10.10.112.0/20"

private_charlie_cidr    = "10.10.128.0/19"
public_charlie_cidr     = "10.10.160.0/20"
#spare_charlie_cidr     = "10.10.176.0/20"

#spare_cidr             = "10.10.192.0/18"
