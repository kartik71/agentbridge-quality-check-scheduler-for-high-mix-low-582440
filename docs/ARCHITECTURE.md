# Architecture Documentation

## Overview
This Iterative-Improve implements Quality Check Scheduler for High Mix Low Volume for Manufacturing use cases.

## Components
1. **Station Intake**: Collect, validate and normalize PLC signals from QMS; attach a runId and timestamp for traceability.
2. **Propose**: Execute propose phase for the Iterative-Improve pattern: persist interim state, enforce guardrails, and emit structured JSON results.
3. **Improve**: Execute improve phase for the Iterative-Improve pattern: persist interim state, enforce guardrails, and emit structured JSON results.
4. **Defect Detection**: Defect Detection across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
5. **Maintenance Plan**: Maintenance Plan across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
6. **Traceability**: Traceability across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
7. **Replenishment**: Replenishment across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
8. **Setup Optimization**: Setup Optimization across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
9. **Dispatch**: Dispatch across joined datasets; branch on thresholds using decision gates; write metrics (success/error counts) for observability.
10. **Maintenance Ticket**: Assemble final payload with status, artifacts, KPIs and audit trail; store to APS; return response JSON for the client.

## Data Flow
- Input: Station Intake
- Processing: 10 sequential steps
- Output: Maintenance Ticket
