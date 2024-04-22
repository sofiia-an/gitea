terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}

data "aws_secretsmanager_secret" "mysql_credentials" {
  name = "mysql-access"

}

data "aws_secretsmanager_secret_version" "secret-version" {
  secret_id = data.aws_secretsmanager_secret.mysql_credentials.id
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}


module "vpc" {
  source = "./modules/vpc"
  application = "Gitea"
  vpc_cidr = "10.0.0.0/16"
}

module "efs" {
  source = "./modules/efs"
  subnet_id = module.vpc.efs_subnet
  security_group_ids = [module.sg.efs_sg_id]
}

module "ec2" {
  source = "./modules/ec2"
  security_groups = [module.sg.ec2_sg_id, module.sg.allow_ssh_id]
  subnets = module.vpc.public_subnets  
}

module "lb" {
  source = "./modules/lb"
  application = "Gitea"
  vpc_id = module.vpc.vpc_id
  target_group_name = "gitea-target-group"
  target_port = 3000
  listener_port = 80
  lb_sg = module.sg.lb_sg_id
  subnets = module.vpc.public_subnets
  instances = module.ec2.ec2_instance
  
}

module "rds" {
  source = "./modules/rds"
  username = jsondecode(data.aws_secretsmanager_secret_version.secret-version.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.secret-version.secret_string)["password"]
  db_name  = jsondecode(data.aws_secretsmanager_secret_version.secret-version.secret_string)["database_name"]
  subnets = module.vpc.private_subnets_rds
  security_groups = [module.sg.rds_sg_id]
}
