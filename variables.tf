variable "create_prometheus_instance" {
  description = "Whether to create prometheus_instance. Monitoring and alert rules require this to be true."
  type        = bool
  default     = false
}

variable "existing_prometheus_instance_id" {
  description = "The ID of an existing Prometheus instance. Used by monitorings and alert_rules when supplied."
  type        = string
  default     = null
}

variable "prometheus_instance" {
  description = "The parameters of the ARMS Prometheus instance."
  type = object({
    cluster_type        = optional(string, "remote-write")
    grafana_instance_id = optional(string, "free")
    vpc_id              = optional(string, null)
    vswitch_id          = optional(string, null)
    security_group_id   = optional(string, null)
    cluster_id          = optional(string, null)
    cluster_name        = optional(string, null)
    sub_clusters_json   = optional(string, null)
    resource_group_id   = optional(string, null)
    duration            = optional(number, null)
    archive_duration    = optional(number, null)
    payment_type        = optional(string, null)
    tags                = optional(map(string), {})
  })
  default = {}
}

variable "create_environments" {
  description = "Whether to create environments."
  type        = bool
  default     = false
}

variable "environments" {
  description = "The ARMS environments keyed by environment name."
  type = map(object({
    environment_type     = string
    environment_sub_type = string
    environment_name     = optional(string, null)
    bind_resource_id     = optional(string, null)
    aliyun_lang          = optional(string, null)
    drop_metrics         = optional(string, null)
    managed_type         = optional(string, null)
    resource_group_id    = optional(string, null)
    tags                 = optional(map(string), {})
  }))
  default = {}
}

variable "env_custom_jobs" {
  description = "The ARMS environment custom jobs keyed by job name. Set environment_key for a module-managed environment or environment_id for an existing environment."
  type = map(object({
    environment_key     = optional(string, null)
    environment_id      = optional(string, null)
    env_custom_job_name = optional(string, null)
    config_yaml         = string
    status              = optional(string, null)
    aliyun_lang         = optional(string, null)
  }))
  default = {}
}

variable "create_env_custom_jobs" {
  description = "Whether to create env_custom_jobs."
  type        = bool
  default     = false
}

variable "addon_releases" {
  description = "The ARMS addon releases keyed by addon release name. Set environment_key for a module-managed environment or environment_id for an existing environment."
  type = map(object({
    environment_key    = optional(string, null)
    environment_id     = optional(string, null)
    addon_name         = string
    addon_version      = string
    addon_release_name = optional(string, null)
    aliyun_lang        = optional(string, null)
    values             = optional(string, null)
  }))
  default = {}
}

variable "create_addon_releases" {
  description = "Whether to create addon_releases."
  type        = bool
  default     = false
}

variable "monitorings" {
  description = "The Prometheus monitorings keyed by an arbitrary name."
  type = map(object({
    type        = string
    config_yaml = string
    status      = optional(string, null)
  }))
  default = {}
}

variable "create_monitorings" {
  description = "Whether to create monitorings."
  type        = bool
  default     = false
}

variable "alert_contacts" {
  description = "The ARMS alert contacts keyed by contact name."
  type = map(object({
    alert_contact_name     = optional(string, null)
    ding_robot_webhook_url = optional(string, null)
    email                  = optional(string, null)
    phone_num              = optional(string, null)
    system_noc             = optional(bool, null)
  }))
  default = {}
}

variable "create_alert_contacts" {
  description = "Whether to create alert_contacts."
  type        = bool
  default     = false
}

variable "alert_contact_groups" {
  description = "The ARMS alert contact groups keyed by group name. contact_keys reference module-managed contacts and contact_ids accepts existing contacts."
  type = map(object({
    alert_contact_group_name = optional(string, null)
    contact_keys             = optional(list(string), [])
    contact_ids              = optional(list(string), [])
  }))
  default = {}
}

variable "create_alert_contact_groups" {
  description = "Whether to create alert_contact_groups."
  type        = bool
  default     = false
}

variable "alert_robots" {
  description = "The ARMS alert robots keyed by robot name."
  type = map(object({
    alert_robot_name = optional(string, null)
    robot_type       = string
    robot_addr       = string
    daily_noc        = optional(bool, null)
    daily_noc_time   = optional(string, null)
  }))
  default = {}
}

variable "create_alert_robots" {
  description = "Whether to create alert_robots."
  type        = bool
  default     = false
}

variable "dispatch_rules" {
  description = "The ARMS dispatch rules keyed by rule name. notify_objects accepts existing targets; contact_keys, contact_group_keys, and robot_keys reference module-managed targets."
  type = map(object({
    dispatch_rule_name = optional(string, null)
    dispatch_type      = optional(string, "CREATE_ALERT")
    is_recover         = optional(bool, null)
    group_rules = object({
      group_wait_time = number
      group_interval  = number
      grouping_fields = list(string)
      repeat_interval = optional(number, null)
    })
    label_match_expression_groups = list(list(object({
      key      = string
      value    = string
      operator = string
    })))
    contact_keys       = optional(list(string), [])
    contact_group_keys = optional(list(string), [])
    robot_keys         = optional(list(string), [])
    notify_objects = optional(list(object({
      notify_object_id = string
      notify_type      = string
      name             = string
    })), [])
    notify_channels   = list(string)
    notify_start_time = string
    notify_end_time   = string
    notify_template = optional(object({
      email_title           = string
      email_content         = string
      email_recover_title   = string
      email_recover_content = string
      sms_content           = string
      sms_recover_content   = string
      tts_content           = string
      tts_recover_content   = string
      robot_content         = string
    }), null)
  }))
  default = {}
}

variable "create_dispatch_rules" {
  description = "Whether to create dispatch_rules."
  type        = bool
  default     = false
}

variable "alert_rules" {
  description = "The Prometheus alert rules keyed by rule name. Set dispatch_rule_key for a module-managed rule or dispatch_rule_id for an existing rule."
  type = map(object({
    prometheus_alert_rule_name = optional(string, null)
    duration                   = string
    expression                 = string
    message                    = string
    notify_type                = optional(string, "ALERT_MANAGER")
    dispatch_rule_key          = optional(string, null)
    dispatch_rule_id           = optional(string, null)
    type                       = optional(string, null)
    labels                     = optional(map(string), {})
    annotations                = optional(map(string), {})
  }))
  default = {}
}

variable "create_alert_rules" {
  description = "Whether to create alert_rules."
  type        = bool
  default     = false
}
