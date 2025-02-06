output "rds_endpoint_order" {
  value       = aws_db_instance.rds_order.endpoint
  description = "Ip para fazer conexão com o banco de order service"
}

output "rds_endpoint_person" {
  value       = aws_db_instance.rds_person.endpoint
  description = "Ip para fazer conexão com o banco de person service"
}