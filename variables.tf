variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "three-tier-demo"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where RDS will be created"
  default = ""
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for RDS"
}
