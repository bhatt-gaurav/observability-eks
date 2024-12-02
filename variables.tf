variable "resource_tags" {
  description = "Tag all resources"
  type = map(string)
  default = {
    Name = "eks-devops"
    Environment = "Dev"
  }
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