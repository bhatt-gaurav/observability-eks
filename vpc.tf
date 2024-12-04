module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = ">= 3.16.0"

  name = "${local.name_suffix}-${local.environment}"
  cidr = var.cidr_block

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true
  single_nat_gateway   = true

  tags = var.resource_tags
  public_subnet_tags = {
    "${local.name_suffix}-${local.environment}-public" = "true"
  }
  private_subnet_tags = {
    "${local.name_suffix}-${local.environment}-private" = "true"
  }
}

# Cluster security group
resource "aws_security_group" "cluster" {
  name_prefix =         local.name_suffix
  description = "EKS cluster security group"
  vpc_id      = module.vpc.vpc_id
  tags = merge(var.tags,
  {
    "Name" = "${local.name_suffix}-eks-cluster-sg"
    "kubernetes.io/cluster/${local.name_suffix}-${local.environment}" = "owned"
  })

  depends_on = [  
    module.vpc,
    module.vpc.private_subnets,
    module.vpc.public_subnets
  ]
  
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  description = "Allow cluster egress access to the internet"
  protocol = "-1"
  from_port = 0
  to_port =  0
  type = "egress"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks = var.cluster_egress_cidr
}

resource "aws_security_group_rule" "cluster_https_worker_ingress" {
  description = "Allow workstation to communicate with the EKS cluster API."
  protocol = "tcp"
  from_port = 443
  to_port =  443
  type = "ingress"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks = var.cluster_endpoint_public_access_cidrs
}

# data

# retrieves private subnet 
data "aws_subnets" "private_subnet" {
  filter {
    name = "tag:${local.name_suffix}-${local.environment}-private"
    values = ["true"]
  }
  filter {
    name = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
  depends_on = [ module.vpc ]
}

# retrieves public subnet 
data "aws_subnets" "public_subnet" {
  filter {
    name = "tag:${local.name_suffix}-${local.environment}-public"
    values = ["true"]
  }
  filter {
    name = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
  depends_on = [ module.vpc ]
}

