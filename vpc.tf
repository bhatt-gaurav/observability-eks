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