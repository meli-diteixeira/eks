# aws_auth.tf
data "aws_eks_cluster_auth" "cluster-auth" {
  name = aws_eks_cluster.cc-eks-cluster.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.cc-eks-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cc-eks-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster-auth.token
}

resource "kubernetes_config_map" "cc-aws-auth-configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = <<YAML
      - rolearn: ${var.role-eks-cluster-worker-node}
        username: system:node:{{EC2PrivateDNSName}}
        groups:
          - system:bootstrappers
          - system:nodes
      - rolearn: ${var.kubectl-role-team}
        username: ${var.meli-user}
        groups:
          - system:masters
      YAML
  }
}
