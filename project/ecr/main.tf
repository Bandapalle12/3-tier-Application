resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.project_name}-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project = var.project_name
  }
}

output "ecr_repo_uri" {
  value = aws_ecr_repository.app_repo.repository_url
}
