apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${certificate_authority}
    server: ${endpoint}
  name: ${cluster_arn}
contexts:
- context:
    cluster: ${cluster_arn}
    user: ${cluster_arn}
  name: ${cluster_arn}
current-context: ${cluster_arn}
kind: Config
users:
- name: arn:aws:eks:us-east-1:345548655173:cluster/eks-devops-Dev
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - ${aws_region}
      - eks
      - get-token
      - --cluster-name
      - ${cluster_name}
      - --output
      - json
      command: aws
