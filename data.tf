data "aws_eks_cluster" "cluster" {
  name = "fastfood-api"
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

data "aws_vpc" "eks_vpc" {
  filter {
    name   = "cidr"
    values = ["10.0.0.0/16"]
  }

  filter {
    name   = "tag:Name"
    values = ["eks-vpc"]
  }
}

data "aws_subnet" "eks_private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["eks-private-subnet"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }

  filter {
    name   = "cidrBlock"
    values = ["10.0.2.0/24"]
  }
}

data "aws_subnet" "eks_private_subnet2" {
  filter {
    name   = "tag:Name"
    values = ["eks-private-subnet-2"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }

  filter {
    name   = "cidrBlock"
    values = ["10.0.3.0/24"]
  }
}

data "kubernetes_secret" "fastfood_secret" {
  metadata {
    name = "fastfood-secret"
  }
}