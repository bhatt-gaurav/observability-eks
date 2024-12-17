resource "kubernetes_namespace" "cloudwatch_namespace" {
  metadata {
    name = var.cloudwatch_namespace
  }
}

resource "helm_release" "fluentbit" {
  depends_on = [ local_file.kubeconfig ]
  name = "fluent-bit"
  namespace = var.cloudwatch_namespace

  repository = "https://aws.github.io/eks-charts"
  chart = "aws-for-fluent-bit"

  values = [
    <<EOF
  config:
    outputs: |
      [OUTPUT]
          Name cloudwatch
          Match  *
          region us-east-1
          log_group_name fluentbit-log-group
          log_stream_prefix fluentbit-
          auto_create_group true
    
    elasticsearch:
      enabled: false
    EOF
  ]
  recreate_pods = true
}

