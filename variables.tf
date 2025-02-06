variable "mongodb_uri" {
  description = "URI para acesso do banco de dados mongoDB payment-service"
  type        = string
  sensitive   = true
}

variable "postgres_user" {
  description = "Usuário do banco de dados"
  type        = string
  sensitive   = true
}

variable "postgres_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "fastfood_mail_password" {
  description = "Senha do email"
  type        = string
  sensitive   = true
}