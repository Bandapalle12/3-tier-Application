terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

provider "docker" {
  registry_auth {
    address  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

module "ecr" {
  source       = "./project/ecr"
  project_name = var.project_name
}



module "network" {
  source       = "./project/network"
  project_name = var.project_name
  vpc_cidr     = "10.0.0.0/16"
}

module "rds" {
  source = "./project/rds"

  project_name       = var.project_name
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
}

module "ecs" {
  source = "./project/ecs"

  project_name         = var.project_name
  region               = var.aws_region

  vpc_id               = module.network.vpc_id
  public_subnet_ids    = module.network.public_subnet_ids
  private_subnet_ids   = module.network.private_subnet_ids

  ecr_image            = "${module.ecr.ecr_repo_uri}:latest"
  rds_secret_arn       = module.rds.secret_arn
  rds_host       = module.rds.rds_host
}
