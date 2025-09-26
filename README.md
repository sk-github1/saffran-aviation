# Saffaran Aviation - Turbine Engine Reports Automation

Automated platform to ingest, process and store turbine engine reports (jets) using AWS, Terraform, Kubernetes, Docker, Jenkins and more.

**Technologies included:** Python (Flask), Docker, Kubernetes manifests, Terraform for AWS (VPC, EKS, S3, ElastiCache Redis, IAM, CloudWatch, CloudTrail), Jenkins bootstrap, Redis caching, GitHub-ready repository structure, security & MFA guidance.

---
## Quick Steps (high-level)
1. Clone this repository locally.
2. Configure AWS CLI (`aws configure`) and enable MFA for the account/role you will use.
3. Create values in `terraform/terraform.tfvars` (or export via environment variables).
4. Run `terraform init` and `terraform apply` inside `terraform/` to provision VPC, S3, EKS, ElastiCache, Jenkins EC2 skeleton, CloudWatch, CloudTrail (review before applying).
5. Build Docker image for the Flask API, push to ECR (or DockerHub) — a helper script is provided at `ci/build_and_push.sh`.
6. Update `k8s/deployment.yaml` with your image location and apply manifests (`kubectl apply -f k8s/`).
7. Configure Jenkins (connect to GitHub, create pipeline job that uses `Jenkinsfile` in repo).
8. Monitor logs in CloudWatch and auditing via CloudTrail.

---
## Repo contents (important files)
- `app/` — Python Flask API that ingests turbine reports and writes raw JSON to S3, caches metadata in Redis.
- `Dockerfile` — Build the container for the API.
- `terraform/` — Terraform configs to provision core infra on AWS (placeholder values, review & adapt to your org policy).
- `k8s/` — Kubernetes manifests for deploying the API onto EKS.
- `jenkins/` — `Jenkinsfile` and a `user_data` script to bootstrap an EC2-based Jenkins master (for lab/testing only).
- `ci/` — helper scripts for building/pushing container images.
- `docs/` — architecture and security notes, IAM policy examples.
- `sample_data/turbine_sample.json` — example telemetry input.

---
## Security & MFA
- Do NOT store credentials in the repo. Use AWS IAM roles, AWS Secrets Manager, and Kubernetes Secrets.
- MFA: Use an IAM user or role with MFA enforced. Use `aws sts get-session-token --serial-number <mfa-arn> --token-code <code>` when running sensitive operations if needed.
- Follow least-privilege for IAM policies (see `docs/iam_policies.md`).

---
## How to push to GitHub
```bash
git init
git add .
git commit -m "Initial commit - Saffaran Aviation automation starter"
# Create remote repository on GitHub, then:
git remote add origin git@github.com:<your-org>/saffaran-aviation-automation.git
git push -u origin main
```

---
## Notes
This repository is a **starter scaffold**. Review each Terraform resource, IAM policy, and Kubernetes manifest before applying to production. The terraform examples use placeholder values and minimal configuration for clarity — production will need hardened security, private subnets, multiple AZs, backups, monitoring alerts and more.

# saffran-aviation
