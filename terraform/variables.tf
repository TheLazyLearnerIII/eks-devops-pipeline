# Cluster name 
variable "epm_cluster" {
    type = string
    default = "flask-app-dev"
}

# Tag for cluster name 
variable "tags" {
    type = map(string)
    default = {
        Environment = "dev"
        Project = "flask-app"
    }
}

# Region
variable "region" {
    description = "AWS EKS region"
    type = string
    default = "us-east-1"
}

# vpc_cidr
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
  default = "10.0.0.0/16"
}

# Instance type
variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t3.micro"
}