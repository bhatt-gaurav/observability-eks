terraform {
  required_version = ">=1.3.1"
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
    backend "s3" {
    bucket         = "terraform-state-gbhatt"
    key            = "Dev/terraform.state"
    region         = "us-east-1"
    dynamodb_table = "remote-state-lock"
    encrypt        = true
  }
}
provider "aws" {
  region = "us-east-1"
}
# Configure the Kubernetes provider to use the EKS cluster's authentication details
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubeconfig.yaml"
  }
}