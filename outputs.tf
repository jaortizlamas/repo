
output "DNS_load_balancer" {
    description = "DNS LB publica"
    value = module.loadbalancer.DNS_load_balancer
}