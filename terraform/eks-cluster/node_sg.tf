resource "aws_security_group" "eks_nodes" {
  name        = var.nodes_sg_name
  description = "Security group for public nodes in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                        = var.nodes_sg_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group" "private_worker_nodes" {
  name        = "${var.nodes_sg_name}-private"
  description = "Security group for private nodes in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                        = "${var.nodes_sg_name}-private"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# SG rules for public nodes.
resource "aws_security_group_rule" "nodes" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

# SG rules for private nodes.
resource "aws_security_group_rule" "private_nodes_ssh" {
  description              = "Allow public nodes to connect ssh with private nodes"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_worker_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_security_group_rule" "private_nodes_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_worker_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}