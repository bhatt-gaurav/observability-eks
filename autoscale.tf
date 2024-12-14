# CPU scale
resource "aws_autoscaling_policy" "cpu_scale_up_policy" {
  for_each = var.node_groups
  name                   = "cpu_scale_up_policy"
  autoscaling_group_name = aws_eks_node_group.worker_nodes[each.key].resources[0].autoscaling_groups[0].name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
   target_value = 80.0
  }
  depends_on = [ aws_eks_node_group.worker_nodes ]
}

# Memory Autoscaling Policy

resource "aws_autoscaling_policy" "mem_scale_up_policy" {
  for_each = { for idx,policy in local.combined_policy_period: "${policy.scaling_period}" => policy }
  name                   = "${each.value.scaling_period}-mem_scale_up_policy"
  autoscaling_group_name = aws_eks_node_group.worker_nodes[each.value.group_name].resources[0].autoscaling_groups[0].name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = each.value.scaling_period

  depends_on = [ aws_eks_node_group.worker_nodes ]
}

resource "aws_autoscaling_policy" "mem_scale_down_policy" {
  for_each = { for idx,policy in local.combined_policy_period: "${policy.scaling_period}" => policy }
  name                   = "${each.value.scaling_period}-mem_scale_down_policy"
  autoscaling_group_name = aws_eks_node_group.worker_nodes[each.value.group_name].resources[0].autoscaling_groups[0].name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = each.value.scaling_period

  depends_on = [ aws_eks_node_group.worker_nodes ]
}

resource "aws_cloudwatch_metric_alarm" "node_memory_utilization_alarm" {
  for_each = toset(var.scaling_period)

  alarm_name                = "node_memory_utilization_high"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "node_memory_utilization"
  namespace                 = "ContainerInsights"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric checks for memory usage above 80%"
  alarm_actions = [aws_autoscaling_policy.mem_scale_up_policy[each.key].arn]
  ok_actions = [aws_autoscaling_policy.mem_scale_down_policy[each.key].arn]
  dimensions = {
    cluster_name = "${aws_eks_cluster.this.name}"
  }
  depends_on = [ aws_eks_node_group.worker_nodes ]


}


