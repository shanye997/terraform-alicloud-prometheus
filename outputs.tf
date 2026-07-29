output "prometheus_instance" {
  description = "The Prometheus instance IDs used by this module."
  value = local.prometheus_cluster_id == null ? null : ({
    id         = var.create_prometheus_instance ? alicloud_arms_prometheus.this[0].id : var.existing_prometheus_instance_id
    cluster_id = local.prometheus_cluster_id
  })
}

output "environments" {
  description = "The environment IDs keyed by environments keys."
  value       = { for key, environment in alicloud_arms_environment.this : key => environment.id }
}

output "env_custom_jobs" {
  description = "The environment custom job IDs keyed by env_custom_jobs keys."
  value       = { for key, job in alicloud_arms_env_custom_job.this : key => job.id }
}

output "addon_releases" {
  description = "The addon release IDs keyed by addon_releases keys."
  value       = { for key, addon_release in alicloud_arms_addon_release.this : key => addon_release.id }
}

output "monitorings" {
  description = "The Prometheus monitoring IDs keyed by monitorings keys."
  value       = { for key, monitoring in alicloud_arms_prometheus_monitoring.this : key => monitoring.id }
}

output "alert_contacts" {
  description = "The alert contact IDs keyed by alert_contacts keys."
  value       = { for key, contact in alicloud_arms_alert_contact.this : key => contact.id }
}

output "alert_contact_groups" {
  description = "The alert contact group IDs keyed by alert_contact_groups keys."
  value       = { for key, contact_group in alicloud_arms_alert_contact_group.this : key => contact_group.id }
}

output "alert_robots" {
  description = "The alert robot IDs keyed by alert_robots keys."
  value       = { for key, robot in alicloud_arms_alert_robot.this : key => robot.id }
}

output "dispatch_rules" {
  description = "The dispatch rule IDs keyed by dispatch_rules keys."
  value       = { for key, dispatch_rule in alicloud_arms_dispatch_rule.this : key => dispatch_rule.id }
}

output "alert_rules" {
  description = "The Prometheus alert rule IDs keyed by alert_rules keys."
  value       = { for key, alert_rule in alicloud_arms_prometheus_alert_rule.this : key => alert_rule.id }
}
