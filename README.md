# DevSecOps Terraform CI/CD Pipeline on Azure DevOps

## Overview

This project demonstrates a **DevSecOps CI/CD pipeline** for provisioning Azure infrastructure using **Terraform**. The pipeline is implemented in **Azure DevOps YAML** and follows Infrastructure as Code (IaC) best practices by validating infrastructure, performing security scanning, and deploying only after successful verification.

The pipeline consists of three stages:

- **Build** – Initializes Terraform, validates configuration, creates an execution plan, and publishes the plan as an artifact.
- **Security** – Scans Terraform code using Checkov to detect security and compliance issues.
- **Deploy** – Downloads the approved Terraform plan and applies it to Azure (only from the `main` branch).

---

# Architecture

```
Feature Branch / Main
          │
          ▼
 Azure DevOps Pipeline
          │
          ▼
 ┌────────────────────────────┐
 │ Build Stage                │
 │ • Terraform Init           │
 │ • Terraform Validate       │
 │ • Terraform Plan           │
 │ • Publish tfplan           │
 └────────────────────────────┘
          │
          ▼
 ┌────────────────────────────┐
 │ Security Stage             │
 │ • Checkov IaC Scan         │
 └────────────────────────────┘
          │
          ▼
      Scan Passed?
          │
         Yes
          │
          ▼
 ┌────────────────────────────┐
 │ Deploy Stage               │
 │ • Download tfplan          │
 │ • Terraform Init           │
 │ • Terraform Apply          │
 └────────────────────────────┘
          │
          ▼
 Azure Infrastructure
```

---

# Pipeline Workflow

## Stage 1 – Build

The Build stage prepares the Terraform deployment.

### Terraform Init

- Downloads required providers.
- Configures the remote backend.
- Connects to Azure Storage Account for state management.

### Terraform Validate

- Checks Terraform syntax.
- Verifies resource references.
- Detects configuration errors before deployment.

### Terraform Plan

- Generates an execution plan.
- Shows infrastructure changes before deployment.
- Saves the plan as `tfplan`.

### Publish Artifact

The generated Terraform plan is published as a Pipeline Artifact.

This ensures:

- The same reviewed plan is deployed.
- No regeneration of plans during deployment.
- Better consistency and auditability.

---

# Stage 2 – Security

This stage performs Infrastructure as Code security scanning.

## Checkov

The pipeline installs **Checkov** and scans all Terraform files.

The scan checks for:

- Publicly accessible resources
- Insecure storage accounts
- Missing encryption
- Weak network security rules
- Compliance violations
- Azure security best practices

If Checkov detects policy violations, the pipeline fails and deployment is blocked.

This follows the DevSecOps principle of **Shift Left Security**, where security is integrated early into the CI/CD pipeline.

---

# Stage 3 – Deploy

Deployment occurs **only** if:

- Build stage succeeds
- Security scan succeeds
- Pipeline is running from the **main** branch

## Download Terraform Plan

Downloads the previously generated `tfplan` artifact.

## Terraform Init

Reinitializes Terraform and reconnects to the remote backend.

## Terraform Apply

Applies the downloaded Terraform plan to Azure.

Because the pipeline uses the previously generated plan, the deployed infrastructure exactly matches what was reviewed during the Build stage.

---

# Branch Strategy

| Branch | Action |
|---------|--------|
| `feature/*` | Runs Build + Security stages |
| `main` | Runs Build + Security + Deploy |

This strategy allows developers to validate infrastructure changes on feature branches while restricting deployments to the main branch.

---

# Security Features

- Infrastructure as Code (Terraform)
- Static security scanning using Checkov
- Remote Terraform State
- Azure Service Connection authentication
- Plan artifact reuse
- Deployment restricted to the main branch
- Automated validation before deployment

---

# Terraform Backend

Terraform state is stored remotely in Azure Storage Account.

Benefits include:

- Shared state management
- State locking
- Version history
- Team collaboration
- Secure remote storage

---

# Pipeline Variables

The pipeline uses an Azure DevOps Variable Group.

Example variables:

| Variable | Description |
|----------|-------------|
| `ARM_SUBSCRIPTION_ID` | Azure Subscription ID |
| `TF_BACKEND_STORAGE` | Storage Account used for Terraform backend |

---

# Azure DevOps Tasks Used

- TerraformTask@5
- PublishPipelineArtifact@1
- DownloadPipelineArtifact@2
- Script Task (Checkov Scan)

---

# Technologies Used

- Azure DevOps
- Terraform
- Microsoft Azure
- Checkov
- YAML Pipelines
- Azure Storage Account (Terraform Backend)

---

# Pipeline Flow

```
Developer Push
      │
      ▼
Azure DevOps Trigger
      │
      ▼
Terraform Init
      │
      ▼
Terraform Validate
      │
      ▼
Terraform Plan
      │
      ▼
Publish tfplan Artifact
      │
      ▼
Checkov Security Scan
      │
      ▼
Security Passed?
      │
     Yes
      │
      ▼
Main Branch?
      │
     Yes
      │
      ▼
Download tfplan
      │
      ▼
Terraform Apply
      │
      ▼
Azure Infrastructure Created
```

---

# DevSecOps Practices Implemented

- Infrastructure as Code (IaC)
- CI/CD Automation
- Shift-Left Security
- Security Gate before Deployment
- Remote State Management
- Immutable Deployment using Terraform Plan Artifact
- Branch-based Deployment Control
- Automated Infrastructure Validation

---

# Author

**Rishi Kejriwal**

DevOps | Azure | Terraform | Docker | Azure DevOps | DevSecOps
