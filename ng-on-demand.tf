# ng-on-demand.tf

resource "aws_eks_node_group" "cc-ng-on-demand-instance" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-ng-on-demand-instance"
  node_role_arn   = "arn:aws:iam::${var.account_id}:role/role-eks-cluster-worker-node"
  subnet_ids      = var.private_subnets
  instance_types  = [var.instance_type]
  disk_size       = var.volume_size

  tags = {
    Criticality = var.criticality
  }

  depends_on = [
    aws_eks_cluster.cc-eks-cluster,
  ]

  scaling_config {
    desired_size = var.min_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  remote_access {
    ec2_ssh_key               = var.key_name
    source_security_group_ids = [var.sg_cluster_worker_node]
  }

  lifecycle {
    create_before_destroy = true
  }
}
