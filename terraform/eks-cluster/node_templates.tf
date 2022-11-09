resource "aws_launch_template" "public_node_template" {
  name          = "public-node-template"
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data = base64encode(<<-EOF
      MIME-Version: 1.0
      Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

      --==MYBOUNDARY==
      Content-Type: text/x-shellscript; charset="us-ascii"

      #!/bin/bash
      sudo mkdir /home/ec2-user/project

      # Mounts nfs.
      sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport nfs-dns:/ /home/ec2-user/project

      --==MYBOUNDARY==--
    EOF
  )

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

  user_data = base64encode("${path.module}/script.txt")

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