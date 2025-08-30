## AWS ECS Terraform CI/CD Boilerplate

A production-ready template for deploying Dockerized web applications to AWS ECS (Fargate) using Terraform for infrastructure management and GitHub Actions for CI/CD automation.

## Table of Contents
- [Project Description](#project-description)
- [Architecture Overview](#architecture-overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Infrastructure Diagram](#infrastructure-diagram)
- [Requirements](#requirements)
- [Repository Structure](#repository-structure)
- [Configuration](#configuration)
- [How it Works](#how-it-works)
- [Setup Instructions](#setup-instructions)
- [CI/CD Pipeline Details](#cicd-pipeline-details)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)
- [References](#references)
- [License](#license)



## Project Description

This repository demonstrates a modern, fully automated approach to deploying and operating a containerized web application on AWS. It leverages Infrastructure as Code (IaC) with Terraform, uses Docker for packaging the application, utilizes AWS Elastic Container Registry (ECR) for image storage, and automates all deployment steps through GitHub Actions.

This template is suitable for production, staging, or personal projects that require fast, repeatable, and secure cloud deployments.

## Architecture Overview

- **Docker**: Packages your application into portable containers.
- **Amazon ECR**: Stores and manages Docker images.
- **Terraform**: Provisions AWS resources (ECS Cluster, Service, Task, VPC, Subnets, ALB, IAM, Security Groups).
- **AWS ECS (Fargate)**: Serverless compute for running containers.
- **AWS ALB**: Application Load Balancer for HTTP/S traffic.
- **GitHub Actions**: Automates build, push, and deploy steps.

## Features

- End-to-end Infrastructure as Code
- Automated image build and deployment on every push
- Zero-downtime ECS deployments
- Secure by default (IAM, Security Groups, environment variables)
- Easily extensible (add databases, queues, S3, etc.)

## Tech Stack

- Application: [Node.js/Flask/React] (customizable)
- Docker
- AWS ECS (Fargate)
- AWS ECR
- AWS VPC, ALB, IAM, Security Groups
- Terraform (>= 1.0)
- GitHub Actions

## Infrastructure Diagram

##  Requirements

- AWS Account with access to ECS, ECR, IAM, VPC, ALB, etc.
- AWS CLI and permissions for provisioning resources
- Terraform (>= 1.0)
- Docker (for local builds and testing)
- GitHub account with Actions enabled

## Repository Structure

```
.
├── app/                  
│   ├── Dockerfile
│   └── index.html
├── terraform/            
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── ...
├── .github/
│   └── workflows/
│       └── deploy.yml     
├── README.md
└── .gitignore
```

---

## Configuration

### AWS Credentials

1. Create an IAM user with permissions for ECS, ECR, VPC, ALB, IAM, CloudWatch, etc.
2. Add the following secrets to your GitHub repository:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`

### Terraform Variables

- Customize values in `terraform/variables.tf` or provide a `terraform.tfvars` file for your environment (VPC CIDR, app name, etc).

### ECR Repository

- Terraform will create the ECR repository, or you can specify an existing one.

## How it Works

1. **Code Push**: Developer pushes to `main` (or another branch).
2. **GitHub Actions**: Pipeline triggers, building Docker image.
3. **ECR Push**: Image is pushed to AWS ECR.
4. **Terraform Deploy**: Terraform applies infrastructure and updates ECS task definition with the new image.
5. **ECS Rolling Update**: ECS pulls the new image and seamlessly updates running tasks.
6. **App Live**: Your app is ready and discoverable via the Load Balancer DNS output by Terraform.

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/rukevweubioworo912/Gitaction-Terraform-aws-Automation.git
cd your-repo
```

### 2. Configure AWS credentials for Terraform (locally, for testing)

```bash
export AWS_ACCESS_KEY_ID=YOUR_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
export AWS_REGION=us-east-1
```

### 3. Initialize and apply Terraform (local testing)

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

### 4. Push code to GitHub

- The GitHub Actions workflow will automatically run on a push to your main branch.

##  CI/CD Pipeline Details

### `.github/workflows/deploy.yml`

```yaml
name: CI/CD Deploy to ECS

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    env:
      AWS_REGION: ${{ secrets.AWS_REGION }}
      ECR_REPOSITORY: ${{ secrets.ECR_REPOSITORY }}
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build Docker image
        run: |
          docker build -t $ECR_REPOSITORY:latest ./app
          docker tag $ECR_REPOSITORY:latest ${{ steps.login-ecr.outputs.registry }}/$ECR_REPOSITORY:latest

      - name: Push image to ECR
        run: |
          docker push ${{ steps.login-ecr.outputs.registry }}/$ECR_REPOSITORY:latest

      - name: Set image URI for Terraform
        run: echo "IMAGE_URI=${{ steps.login-ecr.outputs.registry }}/$ECR_REPOSITORY:latest" >> $GITHUB_ENV

      - name: Terraform Init & Apply
        run: |
          cd terraform
          terraform init
          terraform apply -auto-approve -var="image_uri=$IMAGE_URI"
```

## Security Considerations

- Never commit AWS credentials or Terraform state files to source control.
- Use IAM roles with least privilege.
- Restrict Security Groups to only necessary ports.
- Store secrets (environment variables, credentials) in GitHub Secrets and AWS Parameter Store as appropriate.

## Troubleshooting

- **Pipeline Failed**: Review logs in GitHub Actions.
- **Terraform Error**: Check variable values and AWS resource limits.
- **ECS/ECR Issues**: Validate IAM permissions and resource names.
- **Ports/Access**: Make sure ALB and security groups are configured correctly for HTTP/S.

**Happy Deploying! **
