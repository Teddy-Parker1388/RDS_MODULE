variable "vpc_id" {
  description = "VPC ID"
  type        = string
}


variable "create_subnet_grp" {
  description = "Specifies whether to create subnet group"
  type        = bool
  default     = false

}

variable "id_prefix" {
  description = "Prefix for cluster identifier and subnet group"
  type        = string
  default     = "test"
}

variable "app_env" {
  description = "Deployment Environment"
  type        = string

}

variable "all_tags" {
  description = "A mapping of tags for all resources created"
  type        = map(string)
  default     = {}
}

variable "engine" {
  description = "The database engine to use"
  type        = string

}

variable "database_name" {
  description = "Name of database"
  type        = string

}

variable "master_username" {
  description = "Master Username for RDS Cluster"
  type        = string
}

variable "master_password" {
  description = "Master Password for RDS Cluster"
  type        = string
}


variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}


variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = null
}

variable "create_db_param" {

  description = "Specifies whether to create DB Parameter Group"
  type        = bool
  default     = false

}


variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = false
}

variable "params" {
  description = "DB Parameters"
  type        = list(map(string))
  default     = []
}

variable "db_parameter_group_description" {
  description = "Description of DB Parameter Group"
  type        = string
  default     = null
}

variable "db_subnet_group_description"{
  description = "Description of Subnet Group"
  type        = string
  default     = null
}


variable "db_parameter_group_name_prefix" {
  description = "Prefix for DB Parameter Group name"
  type        = string
  default     = null

}
variable "db_option_group_name_prefix" {
  description = "Prefix for  Option Group name"
  type        = string
  default     = null

}

variable "db_subnet_group_name_prefix" {
  description = "Prefix for  Subnet Group name"
  type        = string
  default     = null

}


variable "family" {
  description = "DB Family"
  type        = string
  default     = null
}

variable "create_db_option" {

  description = "Specifies whether to create DB Option Group"
  type        = bool
  default     = false
}


variable "db_option_group_description" {
  description = "Option Group Description"
  type        = string
  default     = null
}

variable "options" {
  description = "TO_DO"
  type = list(map(object({
    name = string
    settings = object({
      name  = string
      value = string
    })
  })))
  default = []
}

variable "create_auto_backups" {
  description = "Specifies whether to create Automated Backups Replication"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "The KMS encryption key ARN in the destination AWS Region"
  type        = string
  default     = null
}

variable "pre_signed_url" {
  description = "A URL that contains a Signature Version 4 signed request for the StartDBInstanceAutomatedBackupsReplication action to be called in the AWS Region of the source DB instance"
  type        = string
  default     = null
}

variable "retention_period" {
  description = "The retention period for the replicated automated backups"
  type        = number
  default     = 7
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string

}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = null
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter"
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = null
}

variable "license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  type        = string
  default     = null
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = null
}


variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = bool
  default     = false
}

variable "custom_iam_instance_profile" {
  description = "RDS custom iam instance profile"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}


variable "network_type" {
  description = "The type of network stack"
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  type        = string
  default     = null
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}



variable "storage_throughput" {
  description = "Storage throughput value for the DB instance. This setting applies only to the `gp3` storage type. See `notes` for limitations regarding this variable for `gp3`"
  type        = number
  default     = null
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}



variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = null
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  type        = string
  default     = null
}
variable "final_snapshot_identifier" {
  type        = string
  description = "Identifier for the final snapshot to create when deleting the DB instance"
  default     = null
}

variable "final_snapshot_identifier_prefix" {
  description = "The name which is prefixed to the final snapshot on cluster destroy"
  type        = string
  default     = "final"
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  type        = string
  default     = null
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = null
}


variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 0
}


variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero."
  type        = string
  default     = null
}

variable "character_set_name" {
  description = "The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS and Collations and Character Sets for Microsoft SQL Server for more information. This can only be set on creation."
  type        = string
  default     = null
}

variable "timezone" {
  description = "Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information."
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
  type        = list(string)
  default     = []
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = null
}

variable "db_subnet_group_name" {
  description = "Specifies name to be assigned to DB Subnet Group if create_subnet_grp = true "
  type        = string
  default     = null
}

variable "db_option_group_name" {
  description = "Specifies name to be assigned to DB Option Group if create_db_option = true"
  type        = string
  default     = null
}

variable "db_parameter_group_name" {
  description = "Specifies name to be assigned to DB Option Group if create_db_param = true"
  type        = string
  default     = null
}



variable "db_subnet_group_name_ref" {
  description = "Name attribute reference for DB Subnet Group resource  in root module"
  type        = string
  default     = null
}

variable "db_option_group_name_ref" {
  description = "Name attribute reference for DB Option Group resource in root module"
  type        = string
  default     = null
}

variable "db_parameter_group_name_ref" {
  description = "Name attribute reference for DB Option Group resource in root module"
  type        = string
  default     = null
}

variable "use_db_parameter_group_name_prefix" {
  description = "Specifies whether to create a unique db parameter group name beginning with the specified prefix."
  type = bool
  default = false
}

variable "use_db_option_group_name_prefix" {
  description = "Specifies whether to create a unique db option group name beginning with the specified prefix."
  type = bool
  default = false
}

variable "use_subnet_group_name_prefix" {
  description = "Specifies whether to create a unique subnet group name beginning with the specified prefix."
  type = bool
  default = false
}





variable "identifier_prefix" {
  description = "Prefix to use for the DB instance identifier"
  type        = string
  default     = ""
}



variable "use_identifier_prefix" {
  description = "Determines whether to use `identifier` as is or create a unique identifier beginning with `identifier` as the specified prefix"
  type        = bool
  default     = false
}

variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = null
}


variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot"
  type        = bool
  default     = false
}


variable "replica_mode" {
  description = "Specifies whether the replica is in either mounted or open-read-only mode. This attribute is only supported by Oracle instances. Oracle replicas operate in open-read-only mode unless otherwise specified"
  type        = string
  default     = null
}


variable "create_rds_cluster" {
  description = "Specifies whether to create Aurora RDS cluster"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created"
  type = list(string)
  default = []
}


































