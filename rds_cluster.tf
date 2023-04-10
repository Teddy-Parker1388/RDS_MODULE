#CREATE RDS CLUSTER AND INSTANCE WHEN DATABASE  IS AURORA/ RDS CLUSTER IS PREFERRED
resource "aws_rds_cluster" "app_rds_cluster" {
  count = var.create_rds_cluster ? 1 : 0

  database_name             = var.database_name
  master_username           = var.master_username
  master_password           = var.master_password
  cluster_identifier        = "${var.id_prefix}-rds-cluster-${var.app_env}"
  backup_retention_period   = var.retention_period
  final_snapshot_identifier = var.final_snapshot_identifier
  allocated_storage         = var.allocated_storage
  vpc_security_group_ids    = var.vpc_security_group_ids
  skip_final_snapshot       = var.skip_final_snapshot
  deletion_protection       = var.deletion_protection
  port                      = var.port
  network_type              = var.network_type
  storage_encrypted         = var.storage_encrypted

  tags = var.all_tags
}


resource "aws_rds_cluster_instance" "app_rds_instance" {
  count = var.create_rds_cluster ? 1 : 0

  identifier                   = local.instance_identifier
  identifier_prefix            = local.instance_idenitifier_prefix
  instance_class               = var.instance_class
  cluster_identifier           = aws_rds_cluster.app_rds_cluster[0].id
  availability_zone            = var.availability_zone
  engine                       = var.engine
  engine_version               = var.engine_version
  db_subnet_group_name         = local.subnet_group
  db_parameter_group_name      = local.parameter_group
  apply_immediately            = var.apply_immediately
  publicly_accessible          = var.publicly_accessible
  preferred_backup_window      = var.backup_window
  preferred_maintenance_window = var.maintenance_window
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  copy_tags_to_snapshot        = var.copy_tags_to_snapshot
  monitoring_interval     = var.monitoring_interval
  monitoring_role_arn     = var.monitoring_role_arn


  tags = var.all_tags
}
