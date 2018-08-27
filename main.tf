#----root main-------------

provider "aws" {
  region = "${var.aws_region}"
}

variable "common_tags" {
  type = "map"

  default = {
    builtWith      = "terraform"
    terraformGroup = "test-greg-emr"
  }
}

module "vpc" {
  source = "./vpc"
  name   = "test-greg-vpc"

  cidr                 = "10.200.0.0/16"
  private_subnets      = ["10.200.1.0/24"]
  public_subnets       = ["10.200.101.0/24"]
  enable_nat_gateway   = "false"
  enable_s3_endpoint   = "true"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  azs                  = "${var.aws_availability_zone}"
  tags                 = "${var.common_tags}"
}

resource "aws_key_pair" "deployer" {
  key_name   = "tf_key"
  public_key = ""
}

module "emr" {
  source       = "./emr"
  names        = ["test-greg-ceres"]
  master_type  = "m4.xlarge"
  worker_type  = "m4.xlarge"
  worker_count = 4
  vpc_id       = "${module.vpc.vpc_id}"
  subnet_ids   = ["${module.vpc.public_subnets}"]
  ssh_key_ids  = ["${aws_key_pair.deployer.id}"]
  tags         = "${var.common_tags}"
}
