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

resource "docker_image" "app_image" {
  name = "${module.ecr.ecr_repo_uri}:latest"

  build {
    context    = "${path.root}/app"
    dockerfile = "Dockerfile"
  }
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
