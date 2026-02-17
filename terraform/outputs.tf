output "load_balancer_url" {
  value = aws_lb.flask_alb.dns_name
}
