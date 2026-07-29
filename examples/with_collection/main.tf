resource "random_integer" "default" {
  min = 100000
  max = 999999
}

resource "alicloud_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  vpc_name   = "tf-collection-${random_integer.default.result}"
}

resource "alicloud_arms_prometheus" "default" {
  cluster_type        = "remote-write"
  cluster_name        = "tf-collection-${random_integer.default.result}"
  grafana_instance_id = "free"
  tags = {
    Created = "Terraform"
    Example = "with_collection"
  }
}

module "example" {
  source = "../.."

  create_prometheus_instance      = false
  existing_prometheus_instance_id = alicloud_arms_prometheus.default.cluster_id

  create_environments = true
  environments = {
    ecs = {
      environment_type     = "ECS"
      environment_sub_type = "ECS"
      bind_resource_id     = alicloud_vpc.default.id
      environment_name     = "tf-collection-${random_integer.default.result}"
    }
  }

  create_env_custom_jobs = true
  env_custom_jobs = {
    application = {
      environment_key = "ecs"
      status          = "run"
      aliyun_lang     = "en"
      config_yaml     = <<-EOT
        scrape_configs:
          - job_name: application
            metrics_path: /metrics
            static_configs:
              - targets:
                  - 127.0.0.1:9100
      EOT
    }
  }
}
