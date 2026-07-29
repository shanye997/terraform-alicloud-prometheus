terraform-alicloud-prometheus
=====================================================================

本 Module 用于在阿里云创建一个[Prometheus监控](https://help.aliyun.com/product/122122.html).

## 用法

```hcl
module "example" {
  source = "terraform-alicloud-modules/prometheus/alicloud"

  create_prometheus_instance = true
  prometheus_instance = {
    cluster_type        = "remote-write"
    cluster_name        = "example-prometheus"
    grafana_instance_id = "free"
    duration            = 90
    payment_type        = "POSTPAY"
  }
}
```

## 示例

- [`examples/complete`](examples/complete)：创建 Prometheus 实例及其基础告警资源。
- [`examples/with_collection`](examples/with_collection)：在 Module 外创建 Prometheus 实例，再由 Module 创建 ARMS 环境自定义采集任务。
- [`examples/with_alerting`](examples/with_alerting)：在 Module 外创建 Prometheus 实例，再由 Module 配置联系人和分派策略。

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | ~> 1.286 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | ~> 1.286 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_arms_addon_release.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_addon_release) | resource |
| [alicloud_arms_alert_contact.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_alert_contact) | resource |
| [alicloud_arms_alert_contact_group.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_alert_contact_group) | resource |
| [alicloud_arms_alert_robot.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_alert_robot) | resource |
| [alicloud_arms_dispatch_rule.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_dispatch_rule) | resource |
| [alicloud_arms_env_custom_job.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_env_custom_job) | resource |
| [alicloud_arms_environment.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_environment) | resource |
| [alicloud_arms_prometheus.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_prometheus) | resource |
| [alicloud_arms_prometheus_alert_rule.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_prometheus_alert_rule) | resource |
| [alicloud_arms_prometheus_monitoring.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/arms_prometheus_monitoring) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addon_releases"></a> [addon\_releases](#input\_addon\_releases) | The ARMS addon releases keyed by addon release name. Set environment\_key for a module-managed environment or environment\_id for an existing environment. | <pre>map(object({<br/>    environment_key    = optional(string, null)<br/>    environment_id     = optional(string, null)<br/>    addon_name         = string<br/>    addon_version      = string<br/>    addon_release_name = optional(string, null)<br/>    aliyun_lang        = optional(string, null)<br/>    values             = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_alert_contact_groups"></a> [alert\_contact\_groups](#input\_alert\_contact\_groups) | The ARMS alert contact groups keyed by group name. contact\_keys reference module-managed contacts and contact\_ids accepts existing contacts. | <pre>map(object({<br/>    alert_contact_group_name = optional(string, null)<br/>    contact_keys             = optional(list(string), [])<br/>    contact_ids              = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_alert_contacts"></a> [alert\_contacts](#input\_alert\_contacts) | The ARMS alert contacts keyed by contact name. | <pre>map(object({<br/>    alert_contact_name     = optional(string, null)<br/>    ding_robot_webhook_url = optional(string, null)<br/>    email                  = optional(string, null)<br/>    phone_num              = optional(string, null)<br/>    system_noc             = optional(bool, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_alert_robots"></a> [alert\_robots](#input\_alert\_robots) | The ARMS alert robots keyed by robot name. | <pre>map(object({<br/>    alert_robot_name = optional(string, null)<br/>    robot_type       = string<br/>    robot_addr       = string<br/>    daily_noc        = optional(bool, null)<br/>    daily_noc_time   = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_alert_rules"></a> [alert\_rules](#input\_alert\_rules) | The Prometheus alert rules keyed by rule name. Set dispatch\_rule\_key for a module-managed rule or dispatch\_rule\_id for an existing rule. | <pre>map(object({<br/>    prometheus_alert_rule_name = optional(string, null)<br/>    duration                   = string<br/>    expression                 = string<br/>    message                    = string<br/>    notify_type                = optional(string, "ALERT_MANAGER")<br/>    dispatch_rule_key          = optional(string, null)<br/>    dispatch_rule_id           = optional(string, null)<br/>    type                       = optional(string, null)<br/>    labels                     = optional(map(string), {})<br/>    annotations                = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_create_addon_releases"></a> [create\_addon\_releases](#input\_create\_addon\_releases) | Whether to create addon\_releases. | `bool` | `false` | no |
| <a name="input_create_alert_contact_groups"></a> [create\_alert\_contact\_groups](#input\_create\_alert\_contact\_groups) | Whether to create alert\_contact\_groups. | `bool` | `false` | no |
| <a name="input_create_alert_contacts"></a> [create\_alert\_contacts](#input\_create\_alert\_contacts) | Whether to create alert\_contacts. | `bool` | `false` | no |
| <a name="input_create_alert_robots"></a> [create\_alert\_robots](#input\_create\_alert\_robots) | Whether to create alert\_robots. | `bool` | `false` | no |
| <a name="input_create_alert_rules"></a> [create\_alert\_rules](#input\_create\_alert\_rules) | Whether to create alert\_rules. | `bool` | `false` | no |
| <a name="input_create_dispatch_rules"></a> [create\_dispatch\_rules](#input\_create\_dispatch\_rules) | Whether to create dispatch\_rules. | `bool` | `false` | no |
| <a name="input_create_env_custom_jobs"></a> [create\_env\_custom\_jobs](#input\_create\_env\_custom\_jobs) | Whether to create env\_custom\_jobs. | `bool` | `false` | no |
| <a name="input_create_environments"></a> [create\_environments](#input\_create\_environments) | Whether to create environments. | `bool` | `false` | no |
| <a name="input_create_monitorings"></a> [create\_monitorings](#input\_create\_monitorings) | Whether to create monitorings. | `bool` | `false` | no |
| <a name="input_create_prometheus_instance"></a> [create\_prometheus\_instance](#input\_create\_prometheus\_instance) | Whether to create prometheus\_instance. Monitoring and alert rules require this to be true. | `bool` | `false` | no |
| <a name="input_dispatch_rules"></a> [dispatch\_rules](#input\_dispatch\_rules) | The ARMS dispatch rules keyed by rule name. notify\_objects accepts existing targets; contact\_keys, contact\_group\_keys, and robot\_keys reference module-managed targets. | <pre>map(object({<br/>    dispatch_rule_name = optional(string, null)<br/>    dispatch_type      = optional(string, "CREATE_ALERT")<br/>    is_recover         = optional(bool, null)<br/>    group_rules = object({<br/>      group_wait_time = number<br/>      group_interval  = number<br/>      grouping_fields = list(string)<br/>      repeat_interval = optional(number, null)<br/>    })<br/>    label_match_expression_groups = list(list(object({<br/>      key      = string<br/>      value    = string<br/>      operator = string<br/>    })))<br/>    contact_keys       = optional(list(string), [])<br/>    contact_group_keys = optional(list(string), [])<br/>    robot_keys         = optional(list(string), [])<br/>    notify_objects = optional(list(object({<br/>      notify_object_id = string<br/>      notify_type      = string<br/>      name             = string<br/>    })), [])<br/>    notify_channels   = list(string)<br/>    notify_start_time = string<br/>    notify_end_time   = string<br/>    notify_template = optional(object({<br/>      email_title           = string<br/>      email_content         = string<br/>      email_recover_title   = string<br/>      email_recover_content = string<br/>      sms_content           = string<br/>      sms_recover_content   = string<br/>      tts_content           = string<br/>      tts_recover_content   = string<br/>      robot_content         = string<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_env_custom_jobs"></a> [env\_custom\_jobs](#input\_env\_custom\_jobs) | The ARMS environment custom jobs keyed by job name. Set environment\_key for a module-managed environment or environment\_id for an existing environment. | <pre>map(object({<br/>    environment_key     = optional(string, null)<br/>    environment_id      = optional(string, null)<br/>    env_custom_job_name = optional(string, null)<br/>    config_yaml         = string<br/>    status              = optional(string, null)<br/>    aliyun_lang         = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | The ARMS environments keyed by environment name. | <pre>map(object({<br/>    environment_type     = string<br/>    environment_sub_type = string<br/>    environment_name     = optional(string, null)<br/>    bind_resource_id     = optional(string, null)<br/>    aliyun_lang          = optional(string, null)<br/>    drop_metrics         = optional(string, null)<br/>    managed_type         = optional(string, null)<br/>    resource_group_id    = optional(string, null)<br/>    tags                 = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_existing_prometheus_instance_id"></a> [existing\_prometheus\_instance\_id](#input\_existing\_prometheus\_instance\_id) | The ID of an existing Prometheus instance. Used by monitorings and alert\_rules when supplied. | `string` | `null` | no |
| <a name="input_monitorings"></a> [monitorings](#input\_monitorings) | The Prometheus monitorings keyed by an arbitrary name. | <pre>map(object({<br/>    type        = string<br/>    config_yaml = string<br/>    status      = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_prometheus_instance"></a> [prometheus\_instance](#input\_prometheus\_instance) | The parameters of the ARMS Prometheus instance. | <pre>object({<br/>    cluster_type        = optional(string, "remote-write")<br/>    grafana_instance_id = optional(string, "free")<br/>    vpc_id              = optional(string, null)<br/>    vswitch_id          = optional(string, null)<br/>    security_group_id   = optional(string, null)<br/>    cluster_id          = optional(string, null)<br/>    cluster_name        = optional(string, null)<br/>    sub_clusters_json   = optional(string, null)<br/>    resource_group_id   = optional(string, null)<br/>    duration            = optional(number, null)<br/>    archive_duration    = optional(number, null)<br/>    payment_type        = optional(string, null)<br/>    tags                = optional(map(string), {})<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_addon_releases"></a> [addon\_releases](#output\_addon\_releases) | The addon release IDs keyed by addon\_releases keys. |
| <a name="output_alert_contact_groups"></a> [alert\_contact\_groups](#output\_alert\_contact\_groups) | The alert contact group IDs keyed by alert\_contact\_groups keys. |
| <a name="output_alert_contacts"></a> [alert\_contacts](#output\_alert\_contacts) | The alert contact IDs keyed by alert\_contacts keys. |
| <a name="output_alert_robots"></a> [alert\_robots](#output\_alert\_robots) | The alert robot IDs keyed by alert\_robots keys. |
| <a name="output_alert_rules"></a> [alert\_rules](#output\_alert\_rules) | The Prometheus alert rule IDs keyed by alert\_rules keys. |
| <a name="output_dispatch_rules"></a> [dispatch\_rules](#output\_dispatch\_rules) | The dispatch rule IDs keyed by dispatch\_rules keys. |
| <a name="output_env_custom_jobs"></a> [env\_custom\_jobs](#output\_env\_custom\_jobs) | The environment custom job IDs keyed by env\_custom\_jobs keys. |
| <a name="output_environments"></a> [environments](#output\_environments) | The environment IDs keyed by environments keys. |
| <a name="output_monitorings"></a> [monitorings](#output\_monitorings) | The Prometheus monitoring IDs keyed by monitorings keys. |
| <a name="output_prometheus_instance"></a> [prometheus\_instance](#output\_prometheus\_instance) | The Prometheus instance IDs used by this module. |
<!-- END_TF_DOCS -->

提交问题
------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
