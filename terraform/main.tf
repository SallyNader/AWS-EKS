module "vpc" {
  source         = "./vpc"
  cluster_name = var.cluster_name
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}

module "nfs" {
  source      = "./nfs"
  vpc_id      = module.vpc.vpc_main.id
  cidr_blocks = module.vpc.vpc_main.cidr_block
  subnet_ids  = concat(module.vpc.public_subnets_id, module.vpc.private_subnets_id)
}

module "bastion-host" {
  source           = "./bastion"
  desired_capacity = 3
  max_size         = 4
  min_size         = 3
  key              = "ec2-ssh"
  template_name    = "linux"
  subnets_ids      = module.vpc.public_subnets_id
  vpc_id           = module.vpc.vpc_main.id
  instance_type    = "t2.micro"
  image_id         = "ami-0022f774911c1d690"
}

module "eks-cluster" {
  source              = "./eks-cluster"
  # nfs                 = module.nfs.efs
  cluster_name = "${var.cluster_name}"
  cluster_sg_name = "${var.cluster_name}-cluster-sg"
  nodes_sg_name = "${var.cluster_name}-node-sg"
  cluster_subnet_ids = concat(module.vpc.public_subnets_id, module.vpc.private_subnets_id)
  vpc_id           = module.vpc.vpc_main.id
instance_types = ["t2.micro"]
 # Node group configuration (including autoscaling configurations)
    pvt_desired_size = 2
    ami_type = "AL2_x86_64"
    disk_size = 30
    pvt_max_size = 3
    pvt_min_size = 2
    pblc_desired_size = 1
    pblc_max_size = 2
    pblc_min_size = 1
    node_group_name = "${var.cluster_name}-node-group"
    private_subnet_ids = module.vpc.private_subnets_id
    public_subnet_ids = module.vpc.public_subnets_id
}

terraform {
  backend "s3" {
    key            = "terraform/key"
    bucket         = "eks-tf-s3-state"
    region         = "us-east-1"
    dynamodb_table = "eks-tf-state"
  }
}
