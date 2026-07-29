output "prometheus_instance" {
  description = "The externally created Prometheus instance."
  value       = alicloud_arms_prometheus.default
}

output "env_custom_jobs" {
  description = "Created ARMS environment custom job IDs."
  value       = module.example.env_custom_jobs
}
