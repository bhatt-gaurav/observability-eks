locals {
  name_suffix = var.resource_tags["Name"]
  environment = var.resource_tags["Environment"]

  #IAM
  iam_cluster_role_name = var.iam_cluster_role_name != "" ? var.iam_cluster_role_name : null
  iam_cluster_role_name_prefix = var.iam_cluster_role_name != "" ? null : local.name_suffix
  iam_workers_role_name = var.iam_workers_role_name != "" ? var.iam_workers_role_name : null
  iam_workers_role_name_prefix = var.iam_workers_role_name != "" ? null : local.name_suffix
}