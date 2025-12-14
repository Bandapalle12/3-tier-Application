variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecr_image" {
  type = string
}

variable "rds_endpoint" {
  type = string
}

variable "rds_secret_arn" {
  type = string
}
