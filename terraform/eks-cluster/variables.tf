variable "nfs" {}
variable "pvt_max_size" {}
variable "pvt_min_size" {}
variable "key_name" {}
variable "vpc_id" {}
variable "image_id" {}
variable "bastion_id" {}
variable "cluster_name" {}
variable "template_name" {}
variable "instance_type" {}
variable "node_group_name" {}
variable "nodes_sg_name" {}
variable "cluster_sg_name" {}
variable "pvt_desired_size" {}
variable "ami_type" {
  
}
variable "disk_size" {
  
}
variable "subnets_ids" {
  type = list(string)
}
variable "cluster_subnets_ids" {
  type = list(string)
}
variable "eks_cluster_subnet_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}