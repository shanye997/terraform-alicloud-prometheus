output "prometheus_instance" {
  description = "The Prometheus instance created by the module."
  value       = module.example.prometheus_instance
}

output "alert_rules" {
  description = "The alert rules created by the module."
  value       = module.example.alert_rules
}
