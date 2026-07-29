output "prometheus_instance" {
  description = "The externally created Prometheus instance."
  value       = alicloud_arms_prometheus.default
}

output "alert_contacts" {
  description = "Created ARMS alert contact IDs."
  value       = module.example.alert_contacts
}

output "dispatch_rules" {
  description = "Created ARMS dispatch rule IDs."
  value       = module.example.dispatch_rules
}
