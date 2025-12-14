terraform {
  backend "s3" {
    bucket         = "terraform-new-12"
    key            = "AWS/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
