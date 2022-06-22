//----------------------- AWS ACCOUNT ID  ---------------------------------------------------------//
variable "account_id" {
  type = string
}

//----------------------- VPC ID  ---------------------------------------------------------//
variable "vpc_id" {
  type = string
}

//----------------------- Network ---------------------------------------------------------//
variable "private_subnets" {
  type = list(any)
}

//----------------------- EKS Cluster Resources -------------------------------------------//
variable "cluster_name" {
  type = string
}

variable "criticality" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "volume_type" {
  type = string
}

variable "volume_size" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

//--------------------------------- RESOURCES ROLES --------------------------------------//

variable "kubectl_role_team" {
  type = string
}

variable "role_eks_cluster_control_plane" {
  type = string
}

variable "role_eks_cluster_worker_node" {
  type = string
}

//--------------------------------- USER K8S MAP SYSTEM:MASTERS -------------------------//

variable "meli_user" {
  type    = string
}

//--------------------------------- SG CLUSTER  ------------------------------------------//

variable "sg_cluster_control_plane" {
  type = string
}

variable "sg_cluster_worker_node" {
  type = string
}
