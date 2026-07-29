resource "random_integer" "default" {
  min = 100000
  max = 999999
}

resource "alicloud_arms_prometheus" "default" {
  cluster_type        = "remote-write"
  cluster_name        = "tf-alerting-${random_integer.default.result}"
  grafana_instance_id = "free"
  tags = {
    Created = "Terraform"
    Example = "with_alerting"
  }
}

module "example" {
  source = "../.."

  create_prometheus_instance      = false
  existing_prometheus_instance_id = alicloud_arms_prometheus.default.cluster_id

  create_alert_contacts = true
  alert_contacts = {
    oncall = {
      alert_contact_name = "tf-oncall-${random_integer.default.result}"
      email              = "terraform-${random_integer.default.result}@example.com"
    }
  }

  create_alert_contact_groups = true
  alert_contact_groups = {
    oncall = {
      alert_contact_group_name = "tf-oncall-${random_integer.default.result}"
      contact_keys             = ["oncall"]
    }
  }

  create_dispatch_rules = true
  dispatch_rules = {
    application = {
      dispatch_rule_name = "tf-application-${random_integer.default.result}"
      dispatch_type      = "CREATE_ALERT"
      is_recover         = true
      group_rules = {
        group_wait_time = 5
        group_interval  = 15
        repeat_interval = 300
        grouping_fields = ["alertname"]
      }
      label_match_expression_groups = [[{
        key      = "_aliyun_arms_alert_name"
        value    = ".*"
        operator = "re"
      }]]
      contact_group_keys = ["oncall"]
      notify_channels    = ["email"]
      notify_start_time  = "00:00"
      notify_end_time    = "23:59"
    }
  }

}
