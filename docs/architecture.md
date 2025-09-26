# Architecture Overview

1. **Ingestion API (Flask)**: Receives turbine engine telemetry and report JSON via `/report` endpoint.
   - Stores raw JSON into S3 for archival and downstream processing.
   - Caches metadata in Redis (ElastiCache) for quick lookups.
   - Emits logs to stdout (Kubernetes will collect and forward to CloudWatch).

2. **Kubernetes / EKS**: Hosts the API in a scalable deployment with HPA, ALB ingress, and RollingUpdates.

3. **Storage**: S3 for raw files, EBS for persistent node storage, and optional RDS for relational analytics storage.

4. **CI/CD**: Jenkins (or GitHub Actions) builds images and deploys to the EKS cluster. Artifacts pushed to ECR.

5. **Monitoring & Audit**: CloudWatch (logs, metrics, alarms), CloudTrail for API auditing, and optionally GuardDuty for threat detection.

