resource "kubernetes_secret" "fastfood_secret" {
  metadata {
    name = "fastfood-secret"
  }

  data = {
    MONGO_DB_URI                = var.mongodb_uri
    POSTGRES_USER               = var.postgres_user
    POSTGRES_PASSWORD           = var.postgres_password
    FASTFOOD_MAIL_PASSWORD      = var.fastfood_mail_password
    PAYMENT_API_HOST            = "https://${data.aws_api_gateway_rest_api.eks_api.id}.execute-api.us-east-1.amazonaws.com/prod/payments"
    GATEWAY_API_HOST            = "https://${data.aws_api_gateway_rest_api.eks_api.id}.execute-api.us-east-1.amazonaws.com/prod"
    PERSON_API_URL              = "https://${data.aws_api_gateway_rest_api.eks_api.id}.execute-api.us-east-1.amazonaws.com/prod/customers"
    ORDER_DATABASE_URL          = "jdbc:postgresql://${aws_db_instance.rds_order.endpoint}/${aws_db_instance.rds_order.db_name}"
    PERSON_SERVICE_DATABASE_URL = "jdbc:postgresql://${aws_db_instance.rds_person.endpoint}/${aws_db_instance.rds_person.db_name}"
  }

  type = "Opaque"
  depends_on = [
    aws_db_instance.rds_order,
    aws_db_instance.rds_person
  ]
}

# Cria o banco relacional postgres para order
resource "aws_db_instance" "rds_order" {
  identifier           = "postgres-order"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "postgres"
  username             = var.postgres_user
  password             = var.postgres_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
  multi_az             = false
  publicly_accessible  = true
  skip_final_snapshot  = true
  tags = {
    Name = "MyRDSInstanceOrder"
  }
}

# Cria o banco relacional postgres para person
resource "aws_db_instance" "rds_person" {
  identifier           = "postgres-person"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "postgres"
  username             = var.postgres_user
  password             = var.postgres_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
  multi_az             = false
  publicly_accessible  = true
  skip_final_snapshot  = true
  tags = {
    Name = "MyRDSInstancePerson"
  }
}

resource "aws_db_subnet_group" "rds_subnet" {
  name = "rds-subnet-group"
  subnet_ids = [
    data.aws_subnet.eks_private_subnet.id,
    data.aws_subnet.eks_private_subnet2.id
  ]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# Criar o Security Group para o RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group para RDS"
  vpc_id      = data.aws_vpc.eks_vpc.id

  # Regras de segurança (exemplo para permitir tráfego de dentro da VPC)
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]  # Permitir acesso de dentro da VPC
    from_port = 5432  # A porta do PostgreSQL
    to_port = 5432  # A porta do PostgreSQL
    protocol = "tcp"
  }
}