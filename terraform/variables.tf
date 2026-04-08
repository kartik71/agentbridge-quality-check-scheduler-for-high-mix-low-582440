# ═══════════════════════════════════════════════════════════════
# Workspace
# ═══════════════════════════════════════════════════════════════
variable "workspace_url" {
  description = "Databricks workspace URL (e.g., https://adb-1234567890.12.azuredatabricks.net)"
  type        = string
}

variable "workspace_token" {
  description = "Databricks PAT or OAuth token"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

# ═══════════════════════════════════════════════════════════════
# Unity Catalog
# ═══════════════════════════════════════════════════════════════
variable "enable_unity_catalog" {
  description = "Create Unity Catalog resources (catalog, schema, volume)"
  type        = bool
  default     = true
}

variable "catalog_prefix" {
  description = "Prefix for the Unity Catalog catalog name"
  type        = string
  default     = "agentbridge"
}

# ═══════════════════════════════════════════════════════════════
# Identity
# ═══════════════════════════════════════════════════════════════
variable "create_service_principal" {
  description = "Create a dedicated service principal"
  type        = bool
  default     = true
}

# ═══════════════════════════════════════════════════════════════
# Compute
# ═══════════════════════════════════════════════════════════════
variable "runtime_version" {
  description = "Databricks Runtime version"
  type        = string
  default     = "15.4.x-scala2.12"
}

variable "node_type_id" {
  description = "Node type for job clusters"
  type        = string
  default     = "jobs-light-2dbu"
}

variable "default_workers" {
  description = "Default number of workers"
  type        = number
  default     = 1
}

variable "max_workers" {
  description = "Maximum workers allowed by cluster policy"
  type        = number
  default     = 4
}

variable "allowed_node_types" {
  description = "Allowed node types in cluster policy"
  type        = list(string)
  default     = ["Standard_DS3_v2", "Standard_DS4_v2", "Standard_E4s_v3", "i3.xlarge", "i3.2xlarge"]
}

variable "task_timeout_seconds" {
  description = "Task timeout in seconds"
  type        = number
  default     = 3600
}

# ═══════════════════════════════════════════════════════════════
# Job Schedule
# ═══════════════════════════════════════════════════════════════
variable "schedule_cron" {
  description = "Quartz cron expression for job schedule"
  type        = string
  default     = "0 0 * * * ?"
}

variable "schedule_enabled" {
  description = "Enable job schedule"
  type        = bool
  default     = false
}

variable "notebook_base_path" {
  description = "Base path for workflow notebooks in workspace"
  type        = string
  default     = "/Shared/agentbridge"
}

variable "model_endpoint" {
  description = "Foundation model serving endpoint name"
  type        = string
  default     = "databricks-meta-llama-3-1-70b-instruct"
}

# ═══════════════════════════════════════════════════════════════
# Serving Endpoint
# ═══════════════════════════════════════════════════════════════
variable "enable_serving_endpoint" {
  description = "Create a model serving endpoint"
  type        = bool
  default     = false
}

variable "serving_workload_size" {
  description = "Serving endpoint workload size (Small/Medium/Large)"
  type        = string
  default     = "Small"
}

variable "serving_scale_to_zero" {
  description = "Allow serving endpoint to scale to zero"
  type        = bool
  default     = true
}

# ═══════════════════════════════════════════════════════════════
# Notifications
# ═══════════════════════════════════════════════════════════════
variable "alert_emails" {
  description = "Email addresses for job failure alerts"
  type        = list(string)
  default     = []
}
