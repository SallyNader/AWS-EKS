variable "nfs" {}
variable "vpc_id" {}
variable "image_id" {}
variable "key_name" {}
variable "disk_size" {}
variable "pvt_max_size" {}
variable "pvt_min_size" {}
variable "cluster_name" {}
variable "nodes_sg_name" {}
variable "cluster_sg_name" {}
variable "node_group_name" {}
variable "pvt_desired_size" {}


variable "instance_type" {
  default = "t3.medium"
}
variable "cluster_subnet_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}

variable "pblc_desired_size" {
  default = 1
  type    = number
}

variable "pblc_max_size" {
  default = 1
  type    = number
}

variable "pblc_min_size" {
  default = 1
  type    = number
}