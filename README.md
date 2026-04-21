
# Terraform AWS ECS + Lambda Platform

This project demonstrates a production-style, event-driven AWS platform built using Terraform, focusing on scalability, security, and operational reliability.

## Architecture Overview

- AWS VPC with public subnets
- AWS SQS for event-driven messaging
- AWS Lambda for asynchronous event processing
- IAM roles and policies for least-privilege access
- CloudWatch log group with retention settings
- GitHub Actions for Terraform CI validation

## Structure

- `terraform/modules/vpc` – networking layer
- `terraform/modules/sqs` – messaging layer
- `terraform/modules/lambda` – compute and IAM for event processing
- `terraform/environments/dev` – development environment composition
- `lambda/` – Python Lambda handler
- `.github/workflows/terraform.yml` – CI pipeline

## Why this project

This repository was designed to showcase practical AWS platform engineering skills aligned with modern DevOps and Platform Engineer roles:
- Infrastructure as Code with Terraform
- Event-driven architecture with Lambda and SQS
- Modular infrastructure design
- Cloud-native security and observability foundations
- CI/CD validation workflow

## Next planned additions

- ECS Fargate service
- Application Load Balancer
- RDS integration
- CloudWatch alarms and dashboards
- Cost allocation tags and budget alerts