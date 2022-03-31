locals {
  engine         = "aurora-postgresql"
  engine_version = "13.6"
}

resource "aws_rds_cluster" "postgres" {
  cluster_identifier     = "${var.app}-${var.env}"
  engine                 = local.engine
  engine_version         = local.engine_version
  # Have to supply 3 AZs, or RDS auto assigns a third, and it makes the
  # instance dirty on every terraform apply (re-creates cluster)
  availability_zones     = [
    lookup(var.zones, "${var.aws_region}-alpha"),
    lookup(var.zones, "${var.aws_region}-bravo"),
    lookup(var.zones, "${var.aws_region}-charlie")
  ]
  database_name          = "default_db"
  master_username        = var.database_user
  master_password        = var.database_password
  storage_encrypted      = true
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.id

  enabled_cloudwatch_logs_exports = ["postgresql"]
  deletion_protection          = var.deletion_protection
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = "05:00-09:00"
  preferred_maintenance_window = "sun:10:00-sun:14:00"
  final_snapshot_identifier    = "FINAL-${var.app}-${var.env}"
  copy_tags_to_snapshot        = true
  tags = {
    Name = "${var.app}-${var.env}-aurora"
  }
}

resource "aws_rds_cluster_instance" "postgres_instances" {
  count                = 1
  identifier           = "${var.app}-${var.env}-${count.index}"
  cluster_identifier   = aws_rds_cluster.postgres.id
  engine               = local.engine
  engine_version       = local.engine_version
  instance_class       = var.rds_instance_class
  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.id
  tags = {
    Name = "${var.app}-${var.env}-aurora-${count.index}"
  }
}
