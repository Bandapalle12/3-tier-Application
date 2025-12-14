terraform {
  backend "s3" {
    bucket         = "terraform-demo777"
    key            = "AWS/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
