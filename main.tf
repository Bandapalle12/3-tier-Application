terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source = "./modules/ec2"

  ami_id        = "ami-0abcdef1234567890"   # Replace with valid AMI
  instance_type = "t2.micro"
  subnet_id     = "subnet-0123456789abcdef0"
  key_name      = "my-keypair"

  security_group_ids = [
    "sg-0123456789abcdef0"
  ]

  instance_name = "simple-ec2"

  tags = {
    Environment = "dev"
    Owner       = "terraform"
  }
}
