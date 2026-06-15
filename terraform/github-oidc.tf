# Registering Github as a trusted identity provider.
resource "aws_iam_openid_connect_provider" "default" {
    url = "https://token.actions.githubusercontent.com"

    client_id_list = [
        "sts.amazonaws.com"
    ]
    thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
# Creating a role so Github actions can assume with ECR and EKS permissions
resource "aws_iam_role" "github-actions-eks-role" {
    name =  "github-actions-eks-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        
        Statement = [
          {
            Action    = "sts:AssumeRoleWithWebIdentity"
            Effect    = "Allow"
            Sid       = ""
            Principal = {
                Federated = aws_iam_openid_connect_provider.default.arn
            }
            Condition = {
                StringLike = {
                    "token.actions.githubusercontent.com:sub" = "repo:TheLazyLearnerIII/eks-devops-pipeline:*"
                }
            }
        }
    ]
    })
    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attachment-ecr" {
    role = aws_iam_role.github-actions-eks-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "attachment-eks" {
    role = aws_iam_role.github-actions-eks-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "attachment-eks-describe" {
    role       = aws_iam_role.github-actions-eks-role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}