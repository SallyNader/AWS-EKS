variable "vpc_id" {}
variable "elb_type" {}
variable "elb_name" {}
variable "elb_listener_port" {}
variable "target_group_name" {}
variable "target_group_port" {}

variable "subnets_ids" {
  type = list(string)
}