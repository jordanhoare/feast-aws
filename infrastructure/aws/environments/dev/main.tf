# infrastructure/aws/environments/dev/main.tf

terraform {
  backend "s3" {
    region  = "ap-southeast-2"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

module "feast_s3_bucket" {
  source       = "./../../modules/s3"
  project_name = var.project_name
}

resource "aws_s3_object" "driver_stats_upload" {
  bucket = module.feast_s3_bucket.bucket_name
  key    = "driver_stats.parquet"
  source = "${path.module}/../../../../data/driver_stats.parquet"
}

module "iam" {
  source = "./../../modules/iam"
}

module "ecr" {
  source          = "./../../modules/ecr"
  repository_name = "feast-repo"
}

module "vpc" {
  source = "./../../modules/vpc"
}


module "load_balancer" {
  source = "./../../modules/load_balancer"

  lb_name           = "my-alb"
  tg_name           = "my-alb-tg"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.subnet_ids
  security_group_ids = module.vpc.security_group_ids
}


module "ecs" {
  source                      = "./../../modules/ecs"
  security_groups             = module.vpc.security_group_ids
  subnets                     = module.vpc.subnet_ids
  ecs_task_execution_role_arn = module.iam.ecs_task_role_arn
  image                       = "${module.ecr.repository_url}/feast-repo"
  host_port                   = 8000
  container_port              = 8000
  memory                      = 512
  cpu                         = 256
  lb_tg_arn                   = module.load_balancer.lb_tg_arn
}
