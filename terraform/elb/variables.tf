variable "vpc_id" {}
variable "lb_type" {}
variable "elb_name" {}
variable "lb_listener_port" {}
variable "target_group_name" {}
variable "target_group_port" {}

variable "subnets_ids" {
  type = list(string)
}