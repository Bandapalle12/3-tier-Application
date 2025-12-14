terraform {
  backend "s3" {
    bucket         = "terraform-demo32"
    key            = "AWS/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
