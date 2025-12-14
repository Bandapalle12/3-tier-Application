variable "docker_image" {
  description = "Docker image for ECS service (ECR URI)"
  type        = string
  default     = "" 
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "three-tier-demo"
}