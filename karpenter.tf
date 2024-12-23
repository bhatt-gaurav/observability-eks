# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

resource "helm_release" "karpenter" {

  namespace        = var.karpenter_namespace
  create_namespace = true
  name       = "karpenter"
  repository = "https://charts.karpenter.sh/"
  chart      = "karpenter"
  version    = var.karpenter_version

  values = [
    templatefile(
      "${path.module}/templates/values.yaml.tpl",
      {
        "karpenter_iam_role"   = module.iam_assumable_role_karpenter.iam_role_arn,
        "cluster_name"         = aws_eks_cluster.this.name
        "cluster_endpoint"     = aws_eks_cluster.this.endpoint,
        "karpenter_node_group" = aws_eks_node_group.worker_nodes["Devops"].node_group_name,
      }
    )
  ]
}

# A default Karpenter Provisioner manifest is created as a sample.
# Provisioner Custom Resource cannot be created at the same time as the CRD, so manifest file is created instead
# https://github.com/hashicorp/terraform-provider-kubernetes/issues/1367
resource "local_file" "karpenter_provisioner" {
  content = data.template_file.karpenter_provisioner.rendered
  filename = "${path.module}/default-provisioner.yaml"
}