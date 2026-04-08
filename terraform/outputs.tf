output "job_id" {
  description = "Databricks Job ID"
  value       = databricks_job.workflow.id
}

output "job_url" {
  description = "Databricks Job URL"
  value       = "${var.workspace_url}/#job/${databricks_job.workflow.id}"
}

output "catalog_name" {
  description = "Unity Catalog name"
  value       = var.enable_unity_catalog ? databricks_catalog.main[0].name : ""
}

output "schema_name" {
  description = "Unity Catalog schema"
  value       = var.enable_unity_catalog ? databricks_schema.main[0].name : ""
}

output "secret_scope" {
  description = "Secret scope name"
  value       = databricks_secret_scope.main.name
}

output "cluster_policy_id" {
  description = "Cluster policy ID"
  value       = databricks_cluster_policy.workflow.id
}

output "experiment_id" {
  description = "MLflow experiment ID"
  value       = databricks_mlflow_experiment.main.experiment_id
}

output "serving_endpoint_url" {
  description = "Model serving endpoint URL"
  value       = var.enable_serving_endpoint ? "${var.workspace_url}/serving-endpoints/ab-quality_check_scheduler_for_high_mix_low_volume-endpoint" : ""
}

output "service_principal_id" {
  description = "Service principal application ID"
  value       = var.create_service_principal ? databricks_service_principal.workflow[0].application_id : ""
}
