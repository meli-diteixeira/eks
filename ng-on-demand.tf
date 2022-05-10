# ng-on-demand.tf

resource "aws_eks_node_group" "cc-ng-on-demand-instance" {
  cluster_name    = var.cluster-name
  node_group_name = "${var.cluster-name}-cc-ng-on-demand-instance"
  node_role_arn   = var.role-eks-cluster-worker-node
  subnet_ids      = var.private-subnets
  instance_types  = [var.instance-type]
  disk_size       = var.volume-size

  depends_on = [
    aws_eks_cluster.cc-eks-cluster,
  ]

  scaling_config {
    desired_size = var.min-size
    max_size     = var.max-size
    min_size     = var.min-size
  }

  remote_access {
    ec2_ssh_key               = var.key-name
    source_security_group_ids = [var.sg-cluster-worker-node]
  }

  lifecycle {
    create_before_destroy = true
  }
}