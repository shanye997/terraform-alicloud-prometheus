resource "random_integer" "default" {
  min = 100000
  max = 999999
}

module "example" {
  source = "../.."

  create_prometheus_instance = true
  prometheus_instance = {
    cluster_type        = "remote-write"
    cluster_name        = "tf-example-${random_integer.default.result}"
    grafana_instance_id = "free"
    duration            = 90
    archive_duration    = 60
    payment_type        = "POSTPAY"
    tags = {
      Created = "Terraform"
      Example = "complete"
    }
  }

  create_alert_contacts = true
  alert_contacts = {
    default = {
      alert_contact_name = var.alert_contact_name
      email              = var.email
    }
  }

  create_alert_contact_groups = true
  alert_contact_groups = {
    default = {
      alert_contact_group_name = var.alert_contact_group_name
      contact_keys             = ["default"]
    }
  }

  create_dispatch_rules = true
  dispatch_rules = {
    default = {
      dispatch_rule_name = "${var.dispatch_rule_name}-${random_integer.default.result}"
      dispatch_type      = var.dispatch_type
      group_rules = {
        group_wait_time = var.group_wait_time
        group_interval  = var.group_interval
        repeat_interval = var.repeat_interval
        grouping_fields = var.grouping_fields
      }
      label_match_expression_groups = [[{
        key      = "_aliyun_arms_alert_name"
        value    = "tf-testacc-app"
        operator = "eq"
      }]]
      contact_group_keys = ["default"]
      notify_channels    = var.notify_channels
      notify_start_time  = "00:00"
      notify_end_time    = "23:59"
    }
  }

  # Enable only after the newly created Prometheus instance is ready for alert rules.
  create_alert_rules = var.create_alert_rules
  alert_rules = {
    memory_available = {
      duration                   = "1"
      expression                 = "node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 10"
      message                    = "node available memory is less than 10%"
      notify_type                = "ALERT_MANAGER"
      prometheus_alert_rule_name = "tf-memory-available-${random_integer.default.result}"
    }
  }
}
