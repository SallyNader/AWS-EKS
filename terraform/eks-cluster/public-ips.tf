# Gets public ips of EC2 instances to insert it in inventory file.
data "aws_instances" "worker_nodes_ips" {
  instance_tags = {
    Name = "public_worker_node_instance"
  }
  instance_state_names = ["running"]
  depends_on           = [aws_eks_node_group.public]
}

resource "null_resource" "loop_list" {
  provisioner "local-exec" {
    command     = "for item in $ITEMS; do echo $item >> /home/sally/Documents/AWS-EKS/ansible/inventory.txt; done"
    environment = { ITEMS = join(" ", data.aws_instances.worker_nodes_ips.public_ips) }
  }
}