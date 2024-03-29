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

module "s3" {
  source = "./modules/s3" 
  s3_bucket_name = "gitea-app-bucket"
}

module "security_groups" {
  source = "./modules/security_groups"
}

module "elasticbeanstalk" {
  source = "./modules/elastic_beanstalk"
  bucket_name = module.s3.bucket_name
  bucket_key = module.s3.object_key
  security_groups = module.security_groups.sg_name
}
