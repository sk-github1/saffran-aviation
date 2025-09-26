# Security Checklist

- Enforce MFA on all IAM users.
- Use AWS Organizations and SCPs to control account-wide permissions.
- Restrict S3 bucket access with bucket policies and encryption (SSE-S3/SSE-KMS).
- Use IAM roles for service accounts (IRSA) for EKS workloads instead of long-lived keys.
- Store secrets in AWS Secrets Manager or Parameter Store; mount into pods as needed.
- Setup CloudWatch alarms for suspicious activity; integrate with PagerDuty/Slack.
- Enable CloudTrail multi-region with log file validation and central S3 bucket.
