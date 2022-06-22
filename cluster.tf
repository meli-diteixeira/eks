# cluster.tf
# Provider region Informations:
# provider = aws.ohio [us-east-2]
# provider = aws.sao_paulo [sa-east-1]
# provider = aws.viginia [us-east-1] default

resource "aws_eks_cluster" "cc-eks-cluster" {
  name                      = var.cluster_name
  role_arn                  = var.role_eks_cluster_control_plane
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Criticality = var.criticality
  }

  vpc_config {
    security_group_ids      = [var.sg_cluster_control_plane]
    subnet_ids              = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

resource "aws_cloudwatch_log_group" "cc-log-group-eks" {
  name              = "/aws/eks/${var.cluster_name}/cc-lg-${var.cluster_name}"
  retention_in_days = 7

  tags = {
    Criticality = var.criticality
  }
}

output "endpoint" {
  value = aws_eks_cluster.cc-eks-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cc-eks-cluster.certificate_authority[0].data
}
