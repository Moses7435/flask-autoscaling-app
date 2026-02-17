variable "aws_region" {
  default = "ap-southeast-2"
}

variable "docker_image" {
  description = "DockerHub image for Flask app"
  default     = "moses7435/flask-app:latest"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
