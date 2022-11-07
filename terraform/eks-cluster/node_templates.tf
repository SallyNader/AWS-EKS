resource "aws_launch_template" "public_node_template" {
  name          = "public-node-template"
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data = filebase64("${path.module}/script.sh")

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      delete_on_termination = true
      volume_type           = "gp2"
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "public_worker_node_instance"
    }
  }

  tags = {
    template_terraform = "public_node_template"
  }
}

resource "aws_launch_template" "private_node_template" {
  name                   = "private-node-template"
  instance_type          = var.instance_type
  key_name               = var.key_name
  user_data = filebase64("${path.module}/script.sh")
  vpc_security_group_ids = [aws_security_group.private_worker_nodes.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      delete_on_termination = true
      volume_type           = "gp2"
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "private_worker_node_instance"
    }
  }

  tags = {
    template_terraform = "private_node_template"
  }
}