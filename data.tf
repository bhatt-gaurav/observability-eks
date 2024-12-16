# Fetch the EKS cluster information
data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.this.name 
}

# Fetch the authentication token for the EKS cluster
data "aws_eks_cluster_auth" "eks_cluster" {
  name = data.aws_eks_cluster.eks_cluster.name
}