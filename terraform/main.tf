terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-2"
}

// Security Group

resource "aws_security_group" "flask_sg" {
  name        = "flask-sg"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For testing only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Launch Template

resource "aws_launch_template" "flask_lt" {
  name_prefix   = "flask-template"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  # ✅ Add Key Pair
  key_name = "flask"

  # ✅ Security Group
  vpc_security_group_ids = [aws_security_group.flask_sg.id]

  # ✅ User Data Script
  user_data = base64encode(<<EOF
#!/bin/bash
sudo yum update -y

# Install Docker
sudo yum install -y docker

# Enable + Start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Wait for Docker daemon to be ready
sudo sleep 15

# Pull image first (important)
sudo docker pull moses7435/flask-app:latest

# Run container with restart policy
sudo docker run -d \
  --name flask-app \
  --restart always \
  -p 80:5000 \
  moses7435/flask-app:latest
EOF
)
}


// Amazon Linux 2023 AMI

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

// Target Group

resource "aws_lb_target_group" "flask_tg" {
  name     = "flask-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path = "/health"
  }
}

// Load Balancer 

resource "aws_lb" "flask_alb" {
  name               = "flask-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.flask_sg.id]
  subnets            = data.aws_subnets.default.ids
}

// Listener for ALB

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.flask_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_tg.arn
  }
}

// Auto Scaling Group

resource "aws_autoscaling_group" "flask_asg" {
  desired_capacity = 2
  max_size         = 5
  min_size         = 2

  vpc_zone_identifier = data.aws_subnets.default.ids

  launch_template {
    id      = aws_launch_template.flask_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.flask_tg.arn]
}

// VPC and Subnet Data Sources

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
