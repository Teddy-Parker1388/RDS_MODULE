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


