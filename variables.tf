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
