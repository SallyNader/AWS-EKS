# Nodes in private subnets.
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.linux-eks-nodes.id
    version = "$Latest"
  }
  disk_size = var.disk_size

  # ami_type       = var.ami_type
  # instance_types = var.instance_types

  scaling_config {
    desired_size = var.pvt_desired_size
    max_size     = var.pvt_max_size
    min_size     = var.pvt_min_size
  }

  tags = {
    Name = "${var.node_group_name}-private"

  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
    var.nfs
  ]
}

# Nodes in public subnet.
resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.node_group_name}-public"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.linux-eks-nodes.id
    version = "$Latest"
  }
  # ami_type       = var.ami_type
  disk_size = var.disk_size
  # instance_types = var.instance_types

  scaling_config {
    desired_size = var.pblc_desired_size
    max_size     = var.pblc_max_size
    min_size     = var.pblc_min_size
  }

  tags = {
    Name = "${var.node_group_name}-public"
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
    var.nfs
  ]
}

resource "aws_launch_template" "linux-eks-nodes" {
  name          = "${var.node_group_name}-template"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = filebase64("${path.module}/script.sh")
  tags = {
    template_terraform = "${var.node_group_name}-template"
  }

  depends_on = [
    var.nfs
  ]
}