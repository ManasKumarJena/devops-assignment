# devops-assignment
nmmm# DevOps Assignment – Automated EC2 Deployment

## Overview
This project demonstrates a fully automated CI/CD pipeline that provisions AWS infrastructure and deploys a containerized application securely.

## Architecture
- GitHub Actions for CI/CD
- Terraform for infrastructure provisioning
- AWS EC2 with IAM Role
- AWS Secrets Manager for secure configuration
- Dockerized Python application

## Flow
1. Code push triggers GitHub Actions
2. Terraform provisions EC2 and IAM resources
3. EC2 installs Docker automatically
4. Application fetches secrets using IAM role
5. No secrets are hard-coded

## Security
- IAM Role used instead of AWS credentials on EC2
- Secrets stored in AWS Secrets Manager
- GitHub Secrets used for CI authentication
