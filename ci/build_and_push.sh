#!/usr/bin/env bash
# Helper: Build Docker image and push to ECR (or DockerHub). Replace placeholders.
set -euo pipefail
IMAGE_URI=$1  # e.g. 123456789012.dkr.ecr.us-east-1.amazonaws.com/saffaran-api:latest
docker build -t ${IMAGE_URI} .
docker push ${IMAGE_URI}
