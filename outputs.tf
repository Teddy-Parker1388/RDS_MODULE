output "aurora_db_hostname" {
  description = "The Aurora database endpoint"
  value       = try(aws_rds_cluster.db_cluster[0].endpoint, "")
}

output "aurora_db_name" {
  description = "The Aurora  database name"
  value       = try(aws_rds_cluster.db_cluster[0].database_name, "")
}

output "aurora_db_port" {
  description = "The Aurora MySQL port"
  value       = try(aws_rds_cluster.db_cluster[0].port, "")
}



output "db_instance_hostname" {
  description = "The Database Instance endpoint"
  value       = try(aws_db_instance.app_rds_instance[0].endpoint, "")
}

output "db_instance_port" {
  description = "The Database Instance endpoint"
  value       = try(aws_db_instance.app_rds_instance[0].port, "")
}

output "db_instance_name" {
  description = "The Database Instance endpoint"
  value       = try(aws_db_instance.app_rds_instance[0].db_name, "")
}
