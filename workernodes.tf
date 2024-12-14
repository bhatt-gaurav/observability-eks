resource "aws_eks_node_group" "worker_nodes" {
  for_each =   local.node_group_expanded
  node_group_name = lookup(each.value,"name","null") == null ? "node-${local.name_suffix}-${local.environment}" : null
  cluster_name    = aws_eks_cluster.this.id
  node_role_arn   = aws_iam_role.workers.arn
  subnet_ids      = data.aws_subnets.private_subnet.ids
  capacity_type   = lookup(each.value,"capacity_type", null)
  force_update_version = lookup(each.value,"force_update_version",null)
  tags = var.resource_tags
  labels = lookup(var.node_groups[each.key],"k8s_label",{})

  launch_template {
    id = aws_launch_template.worker_nodes_template.id
    version = aws_launch_template.worker_nodes_template.latest_version
  }

  scaling_config {
    desired_size = each.value["desired_capacity"]
    max_size     = each.value["max_capacity"]
    min_size     = each.value["min_capacity"]
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    module.vpc,
    aws_eks_cluster.this,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.WorkersIAMFullAccess,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController

  ]
}