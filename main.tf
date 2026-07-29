locals {
  prometheus_cluster_id = var.create_prometheus_instance ? alicloud_arms_prometheus.this[0].cluster_id : var.existing_prometheus_instance_id

  dispatch_notify_objects = {
    for rule_key, rule in var.create_dispatch_rules ? var.dispatch_rules : {} : rule_key => concat(
      [for notify_object in rule.notify_objects : {
        id   = notify_object.notify_object_id
        name = notify_object.name
        type = notify_object.notify_type
      }],
      [for contact_key in rule.contact_keys : {
        id   = alicloud_arms_alert_contact.this[contact_key].id
        name = contact_key
        type = "ARMS_CONTACT"
      }],
      [for group_key in rule.contact_group_keys : {
        id   = alicloud_arms_alert_contact_group.this[group_key].id
        name = group_key
        type = "ARMS_CONTACT_GROUP"
      }],
      [for robot_key in rule.robot_keys : {
        id   = alicloud_arms_alert_robot.this[robot_key].id
        name = robot_key
        type = "ARMS_ROBOT"
      }]
    )
  }
}

resource "alicloud_arms_prometheus" "this" {
  count = var.create_prometheus_instance ? 1 : 0

  cluster_type        = var.prometheus_instance.cluster_type
  grafana_instance_id = var.prometheus_instance.grafana_instance_id
  vpc_id              = var.prometheus_instance.vpc_id
  vswitch_id          = var.prometheus_instance.vswitch_id
  security_group_id   = var.prometheus_instance.security_group_id
  cluster_id          = var.prometheus_instance.cluster_id
  cluster_name        = var.prometheus_instance.cluster_name
  sub_clusters_json   = var.prometheus_instance.sub_clusters_json
  resource_group_id   = var.prometheus_instance.resource_group_id
  duration            = var.prometheus_instance.duration
  archive_duration    = var.prometheus_instance.archive_duration
  payment_type        = var.prometheus_instance.payment_type
  tags                = var.prometheus_instance.tags
}

resource "alicloud_arms_environment" "this" {
  for_each = var.create_environments ? var.environments : {}

  environment_name     = coalesce(each.value.environment_name, each.key)
  environment_type     = each.value.environment_type
  environment_sub_type = each.value.environment_sub_type
  aliyun_lang          = each.value.aliyun_lang
  bind_resource_id     = each.value.bind_resource_id
  drop_metrics         = each.value.drop_metrics
  managed_type         = each.value.managed_type
  resource_group_id    = each.value.resource_group_id
  tags                 = each.value.tags
}

resource "alicloud_arms_env_custom_job" "this" {
  for_each = var.create_env_custom_jobs ? var.env_custom_jobs : {}

  aliyun_lang         = each.value.aliyun_lang
  config_yaml         = each.value.config_yaml
  env_custom_job_name = coalesce(each.value.env_custom_job_name, each.key)
  environment_id      = each.value.environment_id != null ? each.value.environment_id : alicloud_arms_environment.this[each.value.environment_key].id
  status              = each.value.status
}

resource "alicloud_arms_addon_release" "this" {
  for_each = var.create_addon_releases ? var.addon_releases : {}

  addon_name         = each.value.addon_name
  addon_release_name = coalesce(each.value.addon_release_name, each.key)
  addon_version      = each.value.addon_version
  aliyun_lang        = each.value.aliyun_lang
  environment_id     = each.value.environment_id != null ? each.value.environment_id : alicloud_arms_environment.this[each.value.environment_key].id
  values             = each.value.values
}

resource "alicloud_arms_prometheus_monitoring" "this" {
  for_each = var.create_monitorings ? var.monitorings : {}

  cluster_id  = local.prometheus_cluster_id
  config_yaml = each.value.config_yaml
  status      = each.value.status
  type        = each.value.type
}

resource "alicloud_arms_alert_contact" "this" {
  for_each = var.create_alert_contacts ? var.alert_contacts : {}

  alert_contact_name     = coalesce(each.value.alert_contact_name, each.key)
  ding_robot_webhook_url = each.value.ding_robot_webhook_url
  email                  = each.value.email
  phone_num              = each.value.phone_num
  system_noc             = each.value.system_noc
}

resource "alicloud_arms_alert_contact_group" "this" {
  for_each = var.create_alert_contact_groups ? var.alert_contact_groups : {}

  alert_contact_group_name = coalesce(each.value.alert_contact_group_name, each.key)
  contact_ids = concat(
    each.value.contact_ids,
    [for contact_key in each.value.contact_keys : alicloud_arms_alert_contact.this[contact_key].id]
  )
}

resource "alicloud_arms_alert_robot" "this" {
  for_each = var.create_alert_robots ? var.alert_robots : {}

  alert_robot_name = coalesce(each.value.alert_robot_name, each.key)
  robot_type       = each.value.robot_type
  robot_addr       = each.value.robot_addr
  daily_noc        = each.value.daily_noc
  daily_noc_time   = each.value.daily_noc_time
}

resource "alicloud_arms_dispatch_rule" "this" {
  for_each = var.create_dispatch_rules ? var.dispatch_rules : {}

  dispatch_rule_name = coalesce(each.value.dispatch_rule_name, each.key)
  dispatch_type      = each.value.dispatch_type
  is_recover         = each.value.is_recover

  group_rules {
    group_wait_time = each.value.group_rules.group_wait_time
    group_interval  = each.value.group_rules.group_interval
    grouping_fields = each.value.group_rules.grouping_fields
    repeat_interval = each.value.group_rules.repeat_interval
  }

  label_match_expression_grid {
    dynamic "label_match_expression_groups" {
      for_each = each.value.label_match_expression_groups

      content {
        dynamic "label_match_expressions" {
          for_each = label_match_expression_groups.value

          content {
            key      = label_match_expressions.value.key
            value    = label_match_expressions.value.value
            operator = label_match_expressions.value.operator
          }
        }
      }
    }
  }

  notify_rules {
    dynamic "notify_objects" {
      for_each = local.dispatch_notify_objects[each.key]

      content {
        notify_object_id = notify_objects.value.id
        notify_type      = notify_objects.value.type
        name             = notify_objects.value.name
      }
    }

    notify_channels   = each.value.notify_channels
    notify_start_time = each.value.notify_start_time
    notify_end_time   = each.value.notify_end_time
  }

  dynamic "notify_template" {
    for_each = each.value.notify_template == null ? [] : [each.value.notify_template]

    content {
      email_title           = notify_template.value.email_title
      email_content         = notify_template.value.email_content
      email_recover_title   = notify_template.value.email_recover_title
      email_recover_content = notify_template.value.email_recover_content
      sms_content           = notify_template.value.sms_content
      sms_recover_content   = notify_template.value.sms_recover_content
      tts_content           = notify_template.value.tts_content
      tts_recover_content   = notify_template.value.tts_recover_content
      robot_content         = notify_template.value.robot_content
    }
  }
}

resource "alicloud_arms_prometheus_alert_rule" "this" {
  for_each = var.create_alert_rules ? var.alert_rules : {}

  cluster_id                 = local.prometheus_cluster_id
  prometheus_alert_rule_name = coalesce(each.value.prometheus_alert_rule_name, each.key)
  duration                   = each.value.duration
  expression                 = each.value.expression
  message                    = each.value.message
  notify_type                = each.value.notify_type
  dispatch_rule_id           = each.value.dispatch_rule_id != null ? each.value.dispatch_rule_id : (each.value.dispatch_rule_key == null ? null : alicloud_arms_dispatch_rule.this[each.value.dispatch_rule_key].id)
  type                       = each.value.type

  dynamic "labels" {
    for_each = each.value.labels

    content {
      name  = labels.key
      value = labels.value
    }
  }

  dynamic "annotations" {
    for_each = each.value.annotations

    content {
      name  = annotations.key
      value = annotations.value
    }
  }
}
