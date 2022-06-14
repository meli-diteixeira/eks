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

variable "enabled_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "endpoint_private_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false"
  default     = true
}

variable "endpoint_public_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is true"
  default     = false
}

//--------------------------------- USER K8S MAP SYSTEM:MASTERS -------------------------//

variable "meli_user" {
  type = string
}

//--------------------------------- SG CLUSTER  ------------------------------------------//

variable "sg_cluster_control_plane" {
  type = string
}

variable "sg_cluster_worker_node" {
  type = string
}
