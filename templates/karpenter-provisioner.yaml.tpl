apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: karpenter
spec:
  labels:
    purpose: demo
  provider:
    launchTemplate: ${launch_template}
    subnetSelector:
      ${subnetSelector}: "true"
  requirements:
    - key: node.kubernetes.io/instance-type
      operator: In
      values:
        - ${instance_type_value}
    - key: topology.kubernetes.io/zone
      operator: In
      values:
        - ${topology_zone}
    - key: kubernetes.io/arch
      operator: In
      values: 
        - ${karpenter_ec2_arch}        
    - key: karpenter.sh/capacity-type
      operator: In
      values:
        - ${karpenter_ec2_capacity_type}
  ttlSecondsAfterEmpty: ${ttlSecondsAfterEmpty}
  ttlSecondsUntilExpired: ${ttlSecondsUntilExpired}
