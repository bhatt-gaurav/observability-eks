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

data "template_file" "karpenter_provisioner" {
  template = file("${path.module}/templates/karpenter-provisioner.yaml.tpl")

  vars = {
    launch_template = aws_launch_template.bottlerocket.name
    subnetSelector = format("kubernetes.io/cluster/%s", aws_eks_cluster.this.name)
    instance_type_value = var.node_groups["Devops"]["instance_types"][0]
    topology_zone = join("\n        - ", var.karpenter_vpc_az)
    karpenter_ec2_arch = join("\n        - ", var.karpenter_ec2_arch)
    karpenter_ec2_capacity_type = join("\n        - ", var.karpenter_ec2_capacity_type)
    ttlSecondsAfterEmpty = var.karpenter_ttl_seconds_after_empty
    ttlSecondsUntilExpired  = var.karpenter_ttl_seconds_until_expired

  }
}