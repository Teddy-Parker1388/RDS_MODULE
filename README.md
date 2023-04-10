# Terrfaform Module to create RDS on AWS
----------------------------------------------------

## Resources Supported
* RDS Cluster 
* RDS Cluster Instance
* DB Instance
* DB Paramater Group
* DB Subnet Group
* DB Option Group
-----------------------------------------------------
## Inputs Supported
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|rds_sec_grp_ids|IDs for Security Groups to attach to DB|list(string)|[]|no|
|vpc_id|VPC ID|string| | yes|
|env_type|Deployment Environment Type (prod/non-prod)|string| |yes|
|create_subnet_grp|Specifies whether to create a Subnet Group|bool|false|no|
|id_prefix|Prefix for rds cluster identifier and subnet group|string|null|no|
|app_env|Deployment environment|string| | yes|
|all_tags|A mapping of tags for all resources created|map(string)|{}|no|
|engine|The Database engine|string| | yes|
|database_name|Name of database|string| |yes|
|master_username|Master Username|string| | yes|
|master_password| Master password|string| | yes|
|skip_final_snapshot|Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted|bool|false|no|
|engine_version|The engine version of database|string| | yes|
|create_db_param|Specifies whether to create DB Parameter Group|bool|false|no|
|apply_immediately|Specifies whether any database modifications are applied immediately, or during the next maintenance window|bool|false|no|
|deletion_protection|The database can't be deleted when value is true|bool|false|no|
|params|DB parameters|list(map(string))|[]|no|
|db_param_description|Describes the DB parameter group|string|null|no|
|db_param_name_prefix|Prefix name for DB parameter group|string|null|no|
|family|DB family|string|null|no|
|create_db_option|Specifies whether to create DB Option Group|bool|false|no|
|option_grou_description|Describes DB option group|string|null|no|
|options|Database option objects for the database option group|list(map(object({name=string,settings=object({name=string,value=string})})))|[]|no|
|create_auto_backups|Specifies whether to create automated backups replication|bool|false|no|
|kms_key_arn|The KMS encryption key ARN in the destination AWS Region|string|null|no|
|presigned_url|A URL that contains a Signature Version 4 signed request for the StartDBInstanceAutomatedBackupsReplication action to be called in the AWS Region of the source DB instance|string|null|no|
|retention_period|The retention period for the replicated automated backups|number|7|no|
|instance_class|The instance type of the RDS instance|string| | yes|
|allocated_storage|The allocated storage in gigabytes|string|null|no|
|storage_type|One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter|string|null|no|
|storage_encrypted|Specifies whether the DB instance is encrypted|bool|true|no|
|kms_key_id|The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used|string|null|no|
|license_model|License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1|string|null|no|
|port|The port on which the DB accepts connections|string|null|no|
|iam_database_authentication_enabled|Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled|bool|false|no|
|custom_iam_instance_profile|RDS custom iam instance profile|
|vpc_security_group_ids|List of VPC Security group to associate|list|[]|no|
|network_type|The type of network stack|string|null|no|
|availability_zone|The availability zone of the RDS instance|string|null|no|
|multi_az|Specifies is the RDS instance is multi-az|bool|false|no|
|storage_throughput|Storage throughput value for the DB instance. This setting applies only to the `gp3` storage type. See `notes` for limitations regarding this variable for `gp3|number|null|no|
|publicly_accessible|Specifies if instance is publicly accessible|bool|false|no|
|allow_major_version_upgrade|Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible|bool|false|no|
|auto_minor_version_upgrade|Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window|bool|true|no|
|maintenance_window|The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00|string|null|no|
|snapshot_identifier|Specifies whether or not to create this database from a snapshot|string|null|no|
|final_snapshot_identifier|Identifier for the final snapshot to create when deleting the DB instance|string|null|no|
|final_snapshot_identifier_prefix|The name which is prefixed to the final snapshot on cluster destroy|string|final|no|
|performance_insights_enabled|Specifies whether Performance Insights are enabled|bool|false|no|
|replicate_source_db|Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate.|string|null|no|
|backup_window|The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window|string|null|no|
|max_allocated_storage|Specifies the value for Storage Autoscaling|number|0|no|
|monitoring_interval|The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance.|number|0|no|
|monitoring_role_arn|The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero.|string|null|no|
|character_set_name|The character set name to use for DB encoding in Oracle instances.|string|null|no|
|timezone|Time zone of the DB instance|string|null|no|
|enabled_cloudwatch_logs_exports|List of log types to enable for exporting to CloudWatch logs|list(string)|[]|no|
|delete_automated_backups|Specifies whether to remove automated backups immediately after the DB instance is deleted|bool|true|no|
|backup_retention_period|The days to retain backups|The days to retain backups|number|null|no|
|db_subnet_group_name|Specifies name to be assigned to DB Subnet Group if create_subnet_grp = true|string|null|no|
|db_option_group_name|Specifies name to be assigned to DB Subnet Group if create_subnet_grp = true|string|null|no|
|db_parameter_group_name|Specifies name to be assigned to DB Option Group if create_db_param = true|string|null|no|
|db_subnet_group_name_ref|Name attribute reference for DB Subnet Group resource  in root module|string|null|no|
|db_parameter_group_name_ref|Name attribute reference for DB parameter Group resource  in root module|string|null|no|
|db_option_group_name_ref|Name attribute reference for DB Option Group resource  in root module|string|null|no|
|identifier_prefix|Prefix to use for the DB instance identifier|string|""|no|
|use_identifier_prefix|Determines whether to use `identifier` as is or create a unique identifier beginning with `identifier` as the specified prefix|bool|false|no|
|identifier|The name of the RDS instance|string|null|no|
|copy_tags_to_snapshot|On delete, copy all Instance tags to the final snapshot|bool|false|no|
|replica_mode|Specifies whether the replica is in either mounted or open-read-only mode|string|null|no|
|db_parameter_group_name_prefix|Specifies name prefix to be assigned to DB parameter Group if create_db_param = true and use_db_name_prefix = true|string|null|no|
|use_db_param_name_prefix|Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix|bool|false|no|

-----------------------------------------------------
## Outputs Supported
| Name | Description |
|------|-------------|
|aurora_db_hostname|The Aurora database endpoint|
|aurora_db_name|The Aurora database name|
|aurora_db_port|The Aurora database port|
|db_instance_hostname|The DB instance endpoint|
|db_instance_name|The DB instance database name|
|db_instance_port|The DB instance database port|


# EXAMPLE
