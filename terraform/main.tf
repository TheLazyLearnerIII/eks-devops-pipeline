# VPC module
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "epm-vpc"
    cidr = var.vpc_cidr

    azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_vpn_gateway = true

    # This tag tells EKS to "place internet facing load balancers here" so app is reachable on the internet. 
    public_subnet_tags = {
        "kubernetes.io/role/elb" = "1" # 1 means "on" or "true".
    }
    # This tag tells EKS to "place internal load balancer here" for traffic that stays inside of VPC.
    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = "1" # 1 means "on" or "true".
    }
}

# EKS cluster module
module "eks" {
    source = "terraform-aws-modules/eks/aws"

    name = var.epm_cluster
    kubernetes_version = "1.33"
    

    compute_config = {
        enabled  = true
        node_pools = ["general-purpose"]
    }
    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets

    # Enables the public API server endpoint
    endpoint_public_access = true

    node_security_group_additional_rules = {
        ingress_allow_access_from_alb = {
            type        = "ingress"
            from_port   = 5000
            to_port     = 5000
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allow traffic to Flask app"
        }

    ingress_allow_nodeport = {
        type        = "ingress"
        from_port   = 30000
        to_port     = 32767
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow NodePort range"
    }

    }
    tags = var.tags
}
