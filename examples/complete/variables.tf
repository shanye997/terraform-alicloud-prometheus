#alicloud_arms_alert_contact
variable "alert_contact_name" {
  description = "The name of the alert contact."
  type        = string
  default     = "tf-testacc-user"
}

variable "email" {
  description = "The email address of the alert contact."
  type        = string
  default     = "158@aliyun.com"
}

#alicloud_arms_alert_contact_group
variable "alert_contact_group_name" {
  description = "The name of arms contract group."
  type        = string
  default     = "tf-testacc-group"
}

#alicloud_arms_dispatch_rule
variable "dispatch_rule_name" {
  description = "The rule name of dispatch."
  type        = string
  default     = "tf-testacc-rule"
}

variable "dispatch_type" {
  description = "The type of dispatch."
  type        = string
  default     = "CREATE_ALERT"
}

variable "group_wait_time" {
  description = "The waiting time of arms contract group."
  type        = number
  default     = 10
}

variable "group_interval" {
  description = "The interval time of arms contract group."
  type        = number
  default     = 10
}

variable "repeat_interval" {
  description = "The repeat interval time of arms contract group."
  type        = number
  default     = 61
}

variable "grouping_fields" {
  description = "The files of arms contract group."
  type        = list(string)
  default     = ["CreateDispatchRuleValue"]
}

variable "notify_channels" {
  description = "The name of arms notification."
  type        = list(string)
  default     = ["dingTalk"]
}

variable "create_alert_rules" {
  description = "Whether to create Prometheus alert rules after the instance is ready."
  type        = bool
  default     = false
}
