terraform {
  required_version = ">= 1.5"
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.50"
    }
  }
}

provider "databricks" {
  host  = var.workspace_url
  token = var.workspace_token
}

# ═══════════════════════════════════════════════════════════════
# UNITY CATALOG — Isolated catalog + schema per workflow
# ═══════════════════════════════════════════════════════════════
resource "databricks_catalog" "main" {
  count   = var.enable_unity_catalog ? 1 : 0
  name    = "ab_${var.catalog_prefix}_quality_check_scheduler_for_high_mix_low_volume"
  comment = "AgentBridge: Quality Check Scheduler for High Mix Low Volume"

  properties = {
    environment = var.environment
    managed_by  = "terraform"
    blueprint   = "quality_check_scheduler_for_high_mix_low_volume"
  }
}

resource "databricks_schema" "main" {
  count       = var.enable_unity_catalog ? 1 : 0
  catalog_name = databricks_catalog.main[0].name
  name         = "workflow"
  comment      = "Workflow artifacts for Quality Check Scheduler for High Mix Low Volume"

  properties = {
    environment = var.environment
  }
}

resource "databricks_schema" "models" {
  count        = var.enable_unity_catalog ? 1 : 0
  catalog_name = databricks_catalog.main[0].name
  name         = "models"
  comment      = "MLflow models for Quality Check Scheduler for High Mix Low Volume"
}

resource "databricks_volume" "artifacts" {
  count            = var.enable_unity_catalog ? 1 : 0
  catalog_name     = databricks_catalog.main[0].name
  schema_name      = databricks_schema.main[0].name
  name             = "artifacts"
  volume_type      = "MANAGED"
  comment          = "Workflow artifacts and notebooks"
}

# ═══════════════════════════════════════════════════════════════
# SERVICE PRINCIPAL — Dedicated identity for job execution
# ═══════════════════════════════════════════════════════════════
resource "databricks_service_principal" "workflow" {
  count        = var.create_service_principal ? 1 : 0
  display_name = "ab-quality_check_scheduler_for_high_mix_low_volume-sp"
  active       = true
}

resource "databricks_permissions" "catalog_usage" {
  count     = var.enable_unity_catalog && var.create_service_principal ? 1 : 0
  sql_endpoint_id = ""

  access_control {
    service_principal_name = databricks_service_principal.workflow[0].application_id
    permission_level       = "CAN_USE"
  }
}

# ═══════════════════════════════════════════════════════════════
# SECRET SCOPE — Isolated secrets per workflow
# ═══════════════════════════════════════════════════════════════
resource "databricks_secret_scope" "main" {
  name = "ab-quality_check_scheduler_for_high_mix_low_volume"
}

resource "databricks_secret" "workflow_config" {
  scope        = databricks_secret_scope.main.name
  key          = "workflow_config"
  string_value = jsonencode({
    blueprint_name = "Quality Check Scheduler for High Mix Low Volume"
    environment    = var.environment
    steps          = []
  })
}

# ═══════════════════════════════════════════════════════════════
# CLUSTER POLICY — Resource governance for workflow compute
# ═══════════════════════════════════════════════════════════════
resource "databricks_cluster_policy" "workflow" {
  name = "ab-quality_check_scheduler_for_high_mix_low_volume-policy"
  definition = jsonencode({
    "spark_version" : {
      "type" : "fixed",
      "value" : var.runtime_version
    },
    "num_workers" : {
      "type" : "range",
      "maxValue" : var.max_workers,
      "defaultValue" : var.default_workers
    },
    "node_type_id" : {
      "type" : "allowlist",
      "values" : var.allowed_node_types
    },
    "autotermination_minutes" : {
      "type" : "fixed",
      "value" : 30
    },
    "custom_tags.environment" : {
      "type" : "fixed",
      "value" : var.environment
    },
    "custom_tags.blueprint" : {
      "type" : "fixed",
      "value" : "quality_check_scheduler_for_high_mix_low_volume"
    },
    "custom_tags.managed_by" : {
      "type" : "fixed",
      "value" : "agentbridge"
    }
  })
}

# ═══════════════════════════════════════════════════════════════
# JOB — Workflow execution with task graph
# ═══════════════════════════════════════════════════════════════
resource "databricks_job" "workflow" {
  name = "ab-quality_check_scheduler_for_high_mix_low_volume"

  job_cluster {
    job_cluster_key = "workflow_cluster"
    new_cluster {
      spark_version = var.runtime_version
      node_type_id  = var.node_type_id
      num_workers   = var.default_workers

      spark_conf = {
        "spark.databricks.delta.preview.enabled" = "true"
      }

      custom_tags = {
        environment = var.environment
        blueprint   = "quality_check_scheduler_for_high_mix_low_volume"
        managed_by  = "agentbridge"
      }

      policy_id = databricks_cluster_policy.workflow.id
    }
  }



  schedule {
    quartz_cron_expression = var.schedule_cron
    timezone_id            = "UTC"
    pause_status           = var.schedule_enabled ? "UNPAUSED" : "PAUSED"
  }

  email_notifications {
    on_failure = var.alert_emails
  }

  tags = {
    environment = var.environment
    blueprint   = "quality_check_scheduler_for_high_mix_low_volume"
    managed_by  = "agentbridge"
  }

  max_concurrent_runs = 1
}

# ═══════════════════════════════════════════════════════════════
# MODEL SERVING — Optional, for real-time inference endpoints
# ═══════════════════════════════════════════════════════════════
resource "databricks_model_serving" "workflow" {
  count = var.enable_serving_endpoint ? 1 : 0
  name  = "ab-quality_check_scheduler_for_high_mix_low_volume-endpoint"

  config {
    served_entities {
      entity_name    = var.enable_unity_catalog ? "${databricks_catalog.main[0].name}.${databricks_schema.models[0].name}.quality_check_scheduler_for_high_mix_low_volume" : "quality_check_scheduler_for_high_mix_low_volume"
      entity_version = "1"
      workload_size  = var.serving_workload_size
      scale_to_zero_enabled = var.serving_scale_to_zero
    }

    auto_capture_config {
      enabled = true
      catalog_name = var.enable_unity_catalog ? databricks_catalog.main[0].name : null
      schema_name  = var.enable_unity_catalog ? "models" : null
      table_name_prefix = "ab_quality_check_scheduler_for_high_mix_low_volume_inference"
    }
  }

  tags = {
    environment = var.environment
    blueprint   = "quality_check_scheduler_for_high_mix_low_volume"
  }
}

# ═══════════════════════════════════════════════════════════════
# MLFLOW EXPERIMENT — Tracking for workflow runs
# ═══════════════════════════════════════════════════════════════
resource "databricks_mlflow_experiment" "main" {
  name        = "/Shared/agentbridge/quality_check_scheduler_for_high_mix_low_volume"
  description = "MLflow experiment for Quality Check Scheduler for High Mix Low Volume"
}
