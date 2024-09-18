output "DNS_load_balancer" {
    description = "DNS LB publica"
    value = "http://${aws_lb.alb.dns_name}:${var.puerto_lb}"
}