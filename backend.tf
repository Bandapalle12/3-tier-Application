terraform {
  backend "s3" {
    bucket         = "terraform-state-backend-new"
    key            = "AWS/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
