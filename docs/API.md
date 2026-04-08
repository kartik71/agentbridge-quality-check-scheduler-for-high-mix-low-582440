# API Documentation

## Endpoints
### Station Intake
- **Description**: Collect, validate and normalize PLC signals from QMS; attach a runId and timestamp for traceability.
- **Type**: Processing

### Propose
- **Description**: Execute propose phase for the Iterative-Improve pattern: persist interim state, enforce guardrails, and emit structured JSON results.
- **Type**: Processing

### Improve
- **Description**: Execute improve phase for the Iterative-Improve pattern: persist interim state, enforce guardrails, and emit structured JSON results.
- **Type**: Processing

### Defect Detection
- **Description**: Defect Detection across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
- **Type**: Processing

### Maintenance Plan
- **Description**: Maintenance Plan across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
- **Type**: Processing

### Traceability
- **Description**: Traceability across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
- **Type**: Processing

### Replenishment
- **Description**: Replenishment across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
- **Type**: Processing

### Setup Optimization
- **Description**: Setup Optimization across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
- **Type**: Processing

### Dispatch
- **Description**: Dispatch across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
- **Type**: Processing

### Maintenance Ticket
- **Description**: Assemble final payload with status, artifacts, KPIs and audit trail; store to APS; return response JSON for the client.
- **Type**: Processing
