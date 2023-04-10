locals {
  environment_type            = var.app_env == "prod" ? "prod" : "non-prod"
  instance_identifier         = var.use_identifier_prefix ? null : var.identifier
  instance_idenitifier_prefix = var.use_identifier_prefix ? var.identifier_prefix : null
  subnet_group                = var.create_subnet_grp ? aws_db_subnet_group.db_subnet_group[0].name : var.db_subnet_group_name_ref
  parameter_group             = var.create_db_param ? aws_db_parameter_group.db_param[0].name : var.db_parameter_group_name_ref
  option_group                = var.create_db_option ? aws_db_option_group.db_opt_grp[0].id : var.db_option_group_name_ref

 
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

  count =  var.create_db_option ? 1 : 0

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





