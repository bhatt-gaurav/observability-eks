locals {
  name_suffix = var.resource_tags["Name"]
  environment = var.resource_tags["Environment"]

  # IAM
  iam_cluster_role_name = var.iam_cluster_role_name != "" ? var.iam_cluster_role_name : null
  iam_cluster_role_name_prefix = var.iam_cluster_role_name != "" ? null : local.name_suffix
  iam_workers_role_name = var.iam_workers_role_name != "" ? var.iam_workers_role_name : null
  iam_workers_role_name_prefix = var.iam_workers_role_name != "" ? null : local.name_suffix

  # Node_group expanded
  node_group_expanded = {for k,v in var.node_groups: k => merge(
    {
      desired_capacity = 3
      max_capacity = 6
      min_capacity = 3
    }, v)
  }

  # Combine scaling policy period with nodegroup
  combined_policy_period = flatten([for k,v in var.node_groups: [
       for period in var.scaling_period : {
        group_name = k
        scaling_period = period
       }
    ]
  ])
}