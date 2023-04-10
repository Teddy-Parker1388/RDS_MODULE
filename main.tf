locals {
  environment_type            = var.app_env == "prod" ? "prod" : "non-prod"
  instance_identifier         = var.use_identifier_prefix ? null : var.identifier
  instance_idenitifier_prefix = var.use_identifier_prefix ? var.identifier_prefix : null
  subnet_group                = var.create_subnet_grp ? aws_db_subnet_group.db_subnet_group[0].name : var.db_subnet_group_name_ref
  parameter_group             = var.create_db_param ? aws_db_parameter_group.db_param[0].name : var.db_parameter_group_name_ref
  option_group                = var.create_db_option ? aws_db_option_group.db_opt_grp[0].name : var.db_option_group_name_ref


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

#####################
#CREATE SUBNET GROUP#
#####################
resource "aws_db_subnet_group" "db_subnet_group" {
  count = var.create_subnet_grp ? 1 : 0

  description = var.db_subnet_group_description
  name        = var.use_subnet_group_name_prefix ? null : var.db_subnet_group_name
  name_prefix = var.use_subnet_group_name_prefix ? var.db_subnet_group_name : null
  subnet_ids  = data.aws_subnets.db_tier.ids

  tags = var.all_tags
}



########################################################################
#CREATE RDS CLUSTER  WHEN DATABASE  IS AURORA OR RDS CLUSTER IS PREFERRED#
########################################################################
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

#################################################################################
#CREATE RDS CLUSTER INSTANCE WHEN DATABASE  IS AURORA OR RDS CLUSTER IS PREFERRED#
#################################################################################
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
  monitoring_interval          = var.monitoring_interval
  monitoring_role_arn          = var.monitoring_role_arn


  tags = var.all_tags
}


############################################################################
#CREATE DB PARAMETER GROUP FOR BOTH AURORA AND NON-AURORA DATABASE ENGINES##
############################################################################
resource "aws_db_parameter_group" "db_param" {
  count = var.create_db_param ? 1 : 0

  name        = var.use_db_parameter_group_name_prefix ? null : var.db_parameter_group_name
  name_prefix = var.use_db_parameter_group_name_prefix ? var.db_parameter_group_name_prefix : null
  description = var.db_parameter_group_description
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

#########################################################
#CREATE DB OPTION GROUP FOR  NON-AURORA DATABASE ENGINES#
#########################################################
resource "aws_db_option_group" "db_opt_grp" {

  count = var.create_db_option ? 1 : 0

  name                     = var.use_db_option_group_name_prefix ? null : var.db_option_group_name
  name_prefix              = var.use_db_option_group_name_prefix ? var.db_option_group_name_prefix : null
  engine_name              = var.engine
  major_engine_version     = var.engine_version
  option_group_description = var.db_option_group_description

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

##########################################################
#CREATE A DB INSTANCE WHEN DATABASE ENGINE IS NOT AURORA##
##########################################################
resource "aws_db_instance" "app_rds_instance" {
  count = var.create_rds_cluster ? 0 : 1

  identifier        = local.instance_identifier
  identifier_prefix = local.instance_idenitifier_prefix

  engine                              = var.engine
  engine_version                      = var.engine_version
  instance_class                      = var.instance_class
  allocated_storage                   = var.allocated_storage
  storage_type                        = var.storage_type
  storage_encrypted                   = var.storage_encrypted
  kms_key_id                          = var.kms_key_id
  license_model                       = var.license_model
  db_name                             = var.database_name
  username                            = var.master_username
  password                            = var.master_password
  port                                = var.port
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  custom_iam_instance_profile         = var.custom_iam_instance_profile
  vpc_security_group_ids              = var.vpc_security_group_ids
  db_subnet_group_name                = local.subnet_group
  parameter_group_name                = local.subnet_group
  option_group_name                   = local.option_group
  network_type                        = var.network_type
  availability_zone                   = var.availability_zone
  multi_az                            = var.multi_az
  storage_throughput                  = var.storage_throughput
  publicly_accessible                 = var.publicly_accessible
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  apply_immediately                   = var.apply_immediately
  maintenance_window                  = var.maintenance_window
  snapshot_identifier                 = var.snapshot_identifier
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  skip_final_snapshot                 = var.skip_final_snapshot
  final_snapshot_identifier           = var.final_snapshot_identifier
  replicate_source_db                 = var.replicate_source_db
  replica_mode                        = var.replica_mode
  backup_retention_period             = var.backup_retention_period
  backup_window                       = var.backup_window
  max_allocated_storage               = var.max_allocated_storage
  monitoring_interval                 = var.monitoring_interval
  monitoring_role_arn                 = var.monitoring_role_arn
  character_set_name                  = var.character_set_name
  timezone                            = var.timezone
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  deletion_protection                 = var.deletion_protection
  delete_automated_backups            = var.delete_automated_backups


  tags = var.all_tags

}

################################################################
#CREATE BACKUPS REPLICAS FOR BOTH AURORA AND NON-AURORA ENGINES#
################################################################
resource "aws_db_instance_automated_backups_replication" "app_auto_backups" {
  count = var.create_auto_backups ? 1 : 0

  source_db_instance_arn = can(regex("aurora", "${var.engine}")) ? aws_rds_cluster_instance.app_rds_instance[0].arn : aws_db_instance.app_rds_instance[0].arn
  kms_key_id             = var.kms_key_arn
  pre_signed_url         = var.pre_signed_url
  retention_period       = var.retention_period

}








