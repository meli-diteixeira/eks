//----------------------- VPC ID  ---------------------------------------------------------//
variable "vpc_id" {
  type = string
}

//----------------------- Network ---------------------------------------------------------//

variable "private_subnets" {
  type = list(any)
}

variable "public_subnets" {
  type = list(any)
}

//----------------------- EKS Cluster Resources -------------------------------------------//

variable "cluster_name" {
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

variable "min_size" {}

variable "max_size" {}

//--------------------------------- RESOURCES ROLES --------------------------------------//

variable "kubectl_role_team" {
  default = ""
}

variable "role_eks_cluster_control_plane" {
  default = ""
}

variable "role_eks_cluster_worker_node" {
  default = ""
}

//--------------------------------- USER K8S MAP SYSTEM:MASTERS -------------------------//

variable "meli_user" {
  type    = string
  default = ""
}

//--------------------------------- SG CLUSTER  ------------------------------------------//

variable "sg_cluster_control_plane" {
  default = ""
}

variable "sg_cluster_worker_node" {
  default = ""
}
