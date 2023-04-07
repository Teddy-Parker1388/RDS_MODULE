/*
data "vault_generic_secret" "db" {
  path = var.db_vault_secret_path
}
*/
data "aws_subnets" "db_tier" {

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags   = { 
    Name = "*-${var.env_type}-db-tier*" 
    }

}

resource "aws_security_group" "rds_sec_group" {
  name        = var.rds_sec_grp_name
  description = var.rds_sec_grp_desc
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.rds_ingress
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  dynamic "egress" {
    for_each = var.rds_egress
    content {
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr
    }
  }
}


#CREATING RDS CLUSTER FOR AURORA-*

resource "aws_db_subnet_group" "db_subnet_group" {
  count = can(regex("aurora",var.engine)) ? 1 : 0
  name       = "${var.id_prefix}-subnet-group-${var.app_env}"
  subnet_ids = data.aws_subnets.db_tier.ids

  tags = var.rds_tags
}



resource "aws_rds_cluster" "db_cluster" {
  count = can(regex("aurora","${var.engine}")) ? 1 : 0

  cluster_identifier = "${var.id_prefix}-rds-cluster-${var.app_env}"

  engine         = var.engine
  engine_version = var.engine_version

  database_name   = var.database_name
  master_username = var.master_username
  master_password = var.master_password
  
  db_cluster_parameter_group_name = var.create_db_param ? aws_db_parameter_group.db_param[0].name : null
  

  vpc_security_group_ids = [aws_security_group.rds_sec_group.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group[0].name

  apply_immediately   = var.apply_immediately
  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  tags = var.rds_tags
}


resource "aws_rds_cluster_instance" "app_rds_instance" {
  count = can(regex("aurora","${var.engine}"))  ? 1 : 0
  identifier         = "${var.id_prefix}-rds-instance-${var.app_env}"
  cluster_identifier = aws_rds_cluster.db_cluster[0].cluster_identifier

  engine         = var.engine
  engine_version = var.engine_version

  instance_class       = var.db_instance_type
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group[0].name
  db_parameter_group_name = var.create_db_param ? aws_db_parameter_group.db_param[0].name : null
  

  apply_immediately = var.apply_immediately

  tags = var.rds_tags
}









#CREATING A DB INSTANCE

resource "aws_db_parameter_group" "db_param" {
  count = var.create_db_param ? 1 : 0

  name        = var.db_param_name
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

  tags = var.rds_tags

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_db_option_group" "db_opt_grp" {

  count = can(regex("aurora","${var.engine}")) == false && var.create_db_option ? 1 : 0

  name                    = var.db_option_grp_name
  engine_name             = var.engine
  major_engine_version    = var.engine_version
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





resource "aws_db_instance_automated_backups_replication" "this" {
  count = can(regex("aurora","${var.engine}")) == false && var.create_auto_backups ? 1 : 0

  source_db_instance_arn = can(regex("aurora","${var.engine}")) ? aws_rds_cluster_instance.app_rds_instance[0].arn : aws_db_instance.this[0].arn
  kms_key_id             = var.kms_key_arn
  pre_signed_url         = var.pre_signed_url
  retention_period       = var.retention_period

}





#STUFF TO DO TOMORROW

resource "aws_db_instance" "this" {
  count = can(regex("aurora","${var.engine}")) == false ? 1 : 0

  identifier        = var.identifier
  #identifier_prefix = var.identifier_prefix

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id
  license_model     = var.license_model

  db_name                             = var.db_name
  username                            = var.username
  password                            = var.password
  port                                = var.port
  domain                              = var.domain
  domain_iam_role_name                = var.domain_iam_role_name
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  custom_iam_instance_profile         = var.custom_iam_instance_profile

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  parameter_group_name   = var.create_db_param ? aws_db_parameter_group.db_param[0].name : null
  option_group_name      = var.create_db_option ? aws_db_option_group.db_opt_grp[0].name : null
  network_type           = var.network_type

  availability_zone   = var.availability_zone
  multi_az            = var.multi_az
  iops                = var.iops
  storage_throughput  = var.storage_throughput
  publicly_accessible = var.publicly_accessible
  ca_cert_identifier  = var.ca_cert_identifier

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window


  snapshot_identifier       = var.snapshot_identifier
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  #final_snapshot_identifier = var.final_snapshot_identifier

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null

  replicate_source_db     = var.replicate_source_db
  replica_mode            = var.replica_mode
  backup_retention_period = length(var.blue_green_update) > 0 ? coalesce(var.backup_retention_period, 1) : var.backup_retention_period
  backup_window           = var.backup_window
  max_allocated_storage   = var.max_allocated_storage
  monitoring_interval     = var.monitoring_interval
  monitoring_role_arn     = var.monitoring_interval > 0 ? var.monitoring_role_arn : null

  character_set_name              = var.character_set_name
  timezone                        = var.timezone
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups

  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []

    content {
      restore_time                             = lookup(restore_to_point_in_time.value, "restore_time", null)
      source_db_instance_automated_backups_arn = lookup(restore_to_point_in_time.value, "source_db_instance_automated_backups_arn", null)
      source_db_instance_identifier            = lookup(restore_to_point_in_time.value, "source_db_instance_identifier", null)
      source_dbi_resource_id                   = lookup(restore_to_point_in_time.value, "source_dbi_resource_id", null)
      use_latest_restorable_time               = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", null)
    }
  }

  dynamic "s3_import" {
    for_each = var.s3_import != null ? [var.s3_import] : []

    content {
      source_engine         = "mysql"
      source_engine_version = s3_import.value.source_engine_version
      bucket_name           = s3_import.value.bucket_name
      bucket_prefix         = lookup(s3_import.value, "bucket_prefix", null)
      ingestion_role        = s3_import.value.ingestion_role
    }
  }

  tags = var.tags

  #depends_on = [aws_cloudwatch_log_group.this]

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }


}




