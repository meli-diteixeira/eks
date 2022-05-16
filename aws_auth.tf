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
      - rolearn: "arn:aws:iam::${var.account_id}:role/role-eks-cluster-control-plane"
        username: system:node:{{EC2PrivateDNSName}}
        groups:
          - system:bootstrappers
          - system:nodes
      - rolearn: "arn:aws:iam::${var.account_id}:role/${var.kubectl_role_team}"
        username: ${var.meli_user}
        groups:
          - system:masters
      YAML
  }
}
