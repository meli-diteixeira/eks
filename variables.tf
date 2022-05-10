//----------------------- VPC ID  ---------------------------------------------------------//
variable "vpc-id" {
  type = string
}

//----------------------- Network ---------------------------------------------------------//

variable "private-subnets" {
  type = list(any)
}

variable "public-subnets" {
  type = list(any)
}

//----------------------- EKS Cluster Resources -------------------------------------------//

variable "cluster-name" {
  type = string
}

variable "instance-type" {
  type = string
}

variable "key-name" {
  type = string
}

variable "volume-type" {
  type = string
}

variable "volume-size" {
  type = string
}

variable "min-size" {}

variable "max-size" {}

//--------------------------------- RESOURCES ROLES --------------------------------------//

variable "kubectl-role-team" {
  default = ""
}

variable "role-eks-cluster-control-plane" {
  default = ""
}

variable "role-eks-cluster-worker-node" {
  default = ""
}

//--------------------------------- USER K8S MAP SYSTEM:MASTERS -------------------------//

variable "meli-user" {
  type    = string
  default = ""
}

//--------------------------------- SG CLUSTER  ------------------------------------------//

variable "sg-cluster-control-plane" {
  default = ""
}

variable "sg-cluster-worker-node" {
  default = ""
}
