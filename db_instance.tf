#CREATE A DB INSTANCE WHEN DATABASE ENGINE IS NOT AURORA

resource "aws_db_instance" "app_rds_instance" {
  count = local.create_rds_cluster == 0 ? 1 : 0

  #count = can(regex("aurora", "${var.engine}")) == false ? 1 : 0

  identifier        = local.instance_identifier
  identifier_prefix = local.instance_idenitifier_prefix

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id
  license_model     = var.license_model

  db_name                             = var.database_name
  username                            = var.master_username
  password                            = var.master_password
  port                                = var.port
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  custom_iam_instance_profile         = var.custom_iam_instance_profile

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = local.subnet_group
  parameter_group_name   = local.subnet_group
  option_group_name      = local.option_group
  network_type           = var.network_type

  availability_zone   = var.availability_zone
  multi_az            = var.multi_az
  storage_throughput  = var.storage_throughput
  publicly_accessible = var.publicly_accessible

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window

  snapshot_identifier       = var.snapshot_identifier
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier



  replicate_source_db     = var.replicate_source_db
  replica_mode            = var.replica_mode
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  max_allocated_storage   = var.max_allocated_storage
  monitoring_interval     = var.monitoring_interval
  monitoring_role_arn     = var.monitoring_role_arn

  character_set_name              = var.character_set_name
  timezone                        = var.timezone
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups


  tags = var.all_tags

}