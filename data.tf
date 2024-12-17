# Fetch the EKS cluster information
data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.this.name 
}

# Fetch the authentication token for the EKS cluster
data "aws_eks_cluster_auth" "eks_cluster" {
  name = data.aws_eks_cluster.eks_cluster.name
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig-aws.tpl")

  vars = {
    cluster_arn = aws_eks_cluster.this.arn
    cluster_name = aws_eks_cluster.this.name
    user_name = "gbhatt"
    certificate_authority = aws_eks_cluster.this.certificate_authority[0].data
    endpoint = aws_eks_cluster.this.endpoint
    aws_region = "us-east-1"
  }
}