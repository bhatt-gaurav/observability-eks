resource "aws_eks_cluster" "this" {
  name     = "${local.name_suffix}-${local.environment}"
  version = var.cluster_version
  role_arn = aws_iam_role.cluster.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"] # Enable audit logs

  vpc_config {
    subnet_ids = data.aws_subnets.private_subnet.ids
    endpoint_private_access = true
    endpoint_public_access = true
    security_group_ids = [aws_security_group.cluster.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    module.vpc,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.ClusterIAMFullAccess,
    aws_cloudwatch_log_group.cluster,
    local_file.kubeconfig
  ]
  encryption_config {
    provider {
      key_arn = aws_kms_key.kms_key.arn
    }
    resources = ["secrets"]
  }
  tags = var.resource_tags
}


resource "aws_cloudwatch_log_group" "cluster" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${local.name_suffix}-${local.environment}/cluster"
  retention_in_days = 7

  lifecycle {
    prevent_destroy = false
  }
}

# Create kubeconfig file 

resource "local_file" "kubeconfig" {
  content = data.template_file.kubeconfig.rendered
  filename = "${path.module}/kubeconfig.yaml"
}



# output "endpoint" {
#   value = aws_eks_cluster.example.endpoint
# }

# output "kubeconfig-certificate-authority-data" {
#   value = aws_eks_cluster.example.certificate_authority[0].data
# }