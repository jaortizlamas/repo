output "dns_publica_1" {
    description = "DNS publico del server"
    value = "http://${aws_instance.mi_servidor_1.public_dns}:8080"
}
output "IPv4_privada_1" {
    description = "IPv4 privada"
    value = aws_instance.mi_servidor_1.private_ip
}

output "IPv4_publica_1" {
    description = "IPv4 publica"
    value = aws_instance.mi_servidor_1.public_ip
}
output "dns_publica_2" {
    description = "DNS publico del server"
    value = "http://${aws_instance.mi_servidor_2.public_dns}:8080"
}
output "IPv4_privada_2" {
    description = "IPv4 privada"
    value = aws_instance.mi_servidor_2.private_ip
}

output "IPv4_publica_2" {
    description = "IPv4 publica"
    value = aws_instance.mi_servidor_2.public_ip
}

output "DNS_load_balancer" {
    description = "DNS LB publica"
    value = "http://${aws_lb.alb.dns_name}"
}