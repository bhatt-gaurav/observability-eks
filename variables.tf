variable "resource_tags" {
  description = "Tag all resources"
  type = map(string)
  default = {
    Name = "eks-devops"
    Environment = "Dev"
  }
}

variable "tags" {
  type = map(string)
  default = {}
  
}

variable "cidr_block" {
  description = "CIDR Block for VPC"
  type = string
  default = "10.50.0.0/16"
}

variable "public_subnets" {
  description = "CIDR Block for Public subnet"
  type = list(string)
  default = ["10.50.1.0/24", "10.50.2.0/24"]
}

variable "private_subnets" {
  description = "CIDR Block for Private subnet"
  type = list(string)
  default = ["10.50.5.0/24", "10.50.6.0/24"]
}

variable "cluster_egress_cidr" {
  description = "Allow cluster egress access to the internet"
  type = list(string)
  default = [ "0.0.0.0/0" ]
  
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "Allow workstation to communicate with the EKS cluster API."
  type = list(string)
  default = [ "0.0.0.0/0" ]
  
}

# IAM
variable "iam_cluster_role_name" {
  description = "IAM role name for EKS cluster"
  type = string
  default = ""
}

variable "iam_workers_role_name" {
  description = "IAM role name for EKS cluster worker nodes"
  type = string
  default = ""
}

# CLuster
variable "cluster_version" {
  description = "Provide EKS cluster version"
  type = string
  default = "1.30"
}

# worker nodes

variable "node_groups" {
  description = "map of maps for creating node groups"
  type = any
  default = {
    Devops = {
      desired_capacity = 3
      max_capacity = 4
      min_capacity = 3
      instance_types = ["m6g.large"]
      disk_size = 10
      capacity_type = "ON_DEMAND"
    }
  }
}

# Autoscaling
variable "scaling_period" {
  description = "Scaling period"
  type = list(string)
  default = [ "600", "1200", "1800" ]
  
}

# logging

variable "cloudwatch_namespace" {
  description = "Namespace for cloudwatch"
  type = string
  default = "amazon-cloudwatch"
}

variable "fluent_bit" {
  description = "fluent bit values"
  type = any
  default = {
    devops = {
      "http.server" = "off"
      "http.port"   = "2020"
      "read.head"   = "On"
      "read.tail"   = "Off"
    }
  }
}

variable "aws_region" {
  description = "Region for logs"
  type = string
  default = "us-east-1"
}

# Karpenter
variable "karpenter_namespace" {
  description = "Provide namespace for karpenter"
  type = string
  default = "karpenter"  
}

variable "karpenter_version" {
  description = "Karpenter Version"
  default     = "0.10.0"
  type        = string
}

variable "karpenter_vpc_az" {
  description = "az's for Karpenter"
  type = list(string)
  default = [ "us-east-1a", "us-east-1b" ]
}

variable "karpenter_ec2_arch" {
  description = "List of CPU architecture for the EC2 instances provisioned by Karpenter"
  type        = list(string)
  default     = ["arm64"]
}

variable "karpenter_ec2_capacity_type" {
  description = "EC2 provisioning capacity type"
  type        = list(string)
  default     = ["spot", "on-demand"]
}
variable "karpenter_ttl_seconds_after_empty" {
  description = "Node lifetime after empty"
  type        = number
  default = 300
}

variable "karpenter_ttl_seconds_until_expired" {
  description = "Node maximum lifetime"
  type        = number
  default = 604800  # 7days
}

# s3 Bucket
variable "state_bucket" {
  description = "name for remote state"
  type = string
  default = "terraform-state-gbhatt"
}
