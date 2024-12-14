data "aws_ssm_parameter" "bottlerocket_ami" {
  name = "/aws/service/bottlerocket/aws-k8s-${var.cluster_version}/arm64/latest/image_id"
}

# Launch template for worker nodes
resource "aws_launch_template" "worker_nodes_template" {
  name_prefix =  local.name_suffix
  image_id = data.aws_ssm_parameter.bottlerocket_ami.value
  instance_type = var.node_groups["Devops"]["instance_types"][0]
  tags = var.resource_tags
  user_data = base64encode(<<USERDATA
  [settings.kubernetes]
  api-server = "${aws_eks_cluster.this.endpoint}"
  cluster-certificate = "${aws_eks_cluster.this.certificate_authority.0.data}"
  cluster-name = "${aws_eks_cluster.this.name}"

  [settings.kubernetes.system-reserved]
  cpu = "10m"
  memory = "100Mi"
  ephemeral-storage = "1Gi"
USERDATA
)

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type = "gp3"
      volume_size = var.node_groups["Devops"]["disk_size"]
    }
  }
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    http_endpoint               = "enabled"
  }

}
