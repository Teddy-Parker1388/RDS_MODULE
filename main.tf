
locals{
  environment_type = var.app_env == "prod" ? "prod" : non_pord
}


data "aws_subnets" "db_tier" {

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "*-${local.environment_type}-db-tier*"
  }

}

resource "aws_db_subnet_group" "db_subnet_group" {
  count      = var.create_subnet_grp ? 1 : 0
  name       = "${var.id_prefix}-subnet-group-${var.app_env}"
  subnet_ids = data.aws_subnets.db_tier.ids

  tags = var.all_tags
}


#CREATE RDS CLUSTER AND INSTANCE WHEN DATABASE ENGINE IS AURORA 
resource "aws_rds_cluster" "db_cluster" {
  count = can(regex("aurora", "${var.engine}")) ? 1 : 0

  cluster_identifier = "${var.id_prefix}-rds-cluster-${var.app_env}"

  engine         = var.engine
  engine_version = var.engine_version

  database_name   = var.database_name
  master_username = var.master_username
  master_password = var.master_password

  db_cluster_parameter_group_name = var.create_db_param ? aws_db_parameter_group.db_param[0].name : null


  vpc_security_group_ids = var.rds_sec_grp_ids
  db_subnet_group_name   = var.create_subnet_grp ? aws_db_subnet_group.db_subnet_group[0].name : null

  apply_immediately   = var.apply_immediately
  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  tags = var.all_tags
}


resource "aws_rds_cluster_instance" "app_rds_instance" {
  count              = can(regex("aurora", "${var.engine}")) ? 1 : 0
  identifier         = "${var.id_prefix}-rds-instance-${var.app_env}"
  cluster_identifier = aws_rds_cluster.db_cluster[0].cluster_identifier

  engine         = var.engine
  engine_version = var.engine_version

  instance_class          = var.instance_class
  db_subnet_group_name    = var.create_subnet_grp ? aws_db_subnet_group.db_subnet_group[0].name : var.db_subnet_group_name
  db_parameter_group_name = var.create_db_param ? aws_db_parameter_group.db_param[0].name : null


  apply_immediately = var.apply_immediately

  tags = var.all_tags
}


#CREATE A DB INSTANCE WHEN DATABASE ENGINE IS NOT AURORA
resource "aws_db_instance" "app_rds_instance" {
  count = can(regex("aurora", "${var.engine}")) == false ? 1 : 0

  identifier        = var.use_identifier_prefix ? null : var.identifier
  identifier_prefix = var.use_identifier_prefix ? var.identifier_prefix : null

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
  db_subnet_group_name   = var.create_subnet_grp ? aws_db_subnet_group.db_subnet_group[0].name : var.db_subnet_group_name_ref
  parameter_group_name   = var.create_db_param ? aws_db_parameter_group.db_param[0].name : var.db_parameter_group_name_ref
  option_group_name      = var.create_db_option ? aws_db_option_group.db_opt_grp[0].name : var.db_option_group_name_ref
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

#CREATE DB PARAMETER GROUP FOR BOTH AURORA AND NON-AURORA DATABASE ENGINES

resource "aws_db_parameter_group" "db_param" {
  count = var.create_db_param ? 1 : 0

  name        = var.db_parameter_group_name
  name_prefix = var.db_param_name_prefix
  description = var.db_param_description
  family      = var.family

  dynamic "parameter" {
    for_each = var.params
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = var.all_tags

  lifecycle {
    create_before_destroy = true
  }
}


#CREATE DB OPTION GROUP FOR  NON-AURORA DATABASE ENGINES

resource "aws_db_option_group" "db_opt_grp" {

  count = can(regex("aurora", "${var.engine}")) == false && var.create_db_option ? 1 : 0

  name                     = var.db_option_group_name
  engine_name              = var.engine
  major_engine_version     = var.engine_version
  option_group_description = var.option_group_description

  dynamic "option" {
    for_each = var.options

    content {
      option_name = option.value["name"]

      dynamic "option_settings" {
        for_each = option.value["settings"]

        content {
          name  = option_settings.value["name"]
          value = option_settings.value["value"]
        }
      }
    }
  }
}

#CREATE BACKUPS REPLICAS FOR BOTH AURORA AND NON-AURORA ENGINES
resource "aws_db_instance_automated_backups_replication" "app_auto_backups" {
  count = var.create_auto_backups ? 1 : 0

  source_db_instance_arn = can(regex("aurora", "${var.engine}")) ? aws_rds_cluster_instance.app_rds_instance[0].arn : aws_db_instance.app_rds_instance[0].arn
  kms_key_id             = var.kms_key_arn
  pre_signed_url         = var.pre_signed_url
  retention_period       = var.retention_period

}





