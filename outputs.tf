output "dns_publica_1" {
    description = "DNS publico del server"

    value = [ for servidor in aws_instance.servidor :
    "http://${servidor.public_dns}:${var.puerto_servidor}"
    ]
}


output "DNS_load_balancer" {
    description = "DNS LB publica"
    value = "http://${aws_lb.alb.dns_name}:${var.puerto_lb}"
}