output "alb_dns" {
  value = module.alb.alb_dns_name
}

output "aurora_endpoint" {
  value = module.aurora.endpoint
}
