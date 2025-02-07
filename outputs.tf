output "rds_endpoint_order" {
  value       = "jdbc:postgresql://${aws_db_instance.rds_order.endpoint}/${aws_db_instance.rds_order.db_name}"
  description = "Ip para fazer conexão com o banco de order service"
}

output "rds_endpoint_person" {
  value       = "jdbc:postgresql://${aws_db_instance.rds_person.endpoint}/${aws_db_instance.rds_person.db_name}"
  description = "Ip para fazer conexão com o banco de person service"
}