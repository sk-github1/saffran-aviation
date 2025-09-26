# Example Least-Privilege IAM Policies (SAMPLE)

## S3 write-only for ingestion service
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject","s3:PutObjectAcl"],
      "Resource": ["arn:aws:s3:::saffaran-turbine-raw-*/*"] 
    }
  ]
}
```

## Redis (ElastiCache) typically uses VPC-level security groups rather than IAM for access control.
