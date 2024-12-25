# Map admin and developer users to aws-auth config map

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = jsonencode([
     {
       rolearn  = aws_iam_role.workers.arn
       username = "system:node:{{EC2PrivateDNSName}}"
       groups   = ["system:bootstrappers", "system:nodes"]
     }
   ])
    mapUsers = jsonencode([
      {
        userarn  = "arn:aws:iam::345548655173:user/gbhatt"
        username = "gbhatt"
        groups   = ["system:masters"]
      },
      {
        userarn  = "arn:aws:iam::345548655173:user/gbhatt-dev"
        username = "gbhatt-dev"
        groups   = ["developer-group"]
      }
    ])
  }
  depends_on = [
        aws_eks_cluster.this
    ]

}

# Cluster role for developer user

resource "kubernetes_cluster_role" "developer_role" {
  metadata {
    name = "developer-role"
  }

  rule {
    api_groups = [""]
    resources  = ["pods","services","configmaps","secrets"]
    verbs      = ["get", "list", "watch"]
  }
    rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch","create","update","delete"]
  }
}

# Cluster role binding for developer user
resource "kubernetes_cluster_role_binding" "developer_role_binding" {
  metadata {
    name = "developer-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.developer_role.metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = "developer-group"
    api_group = "rbac.authorization.k8s.io"
  }
}