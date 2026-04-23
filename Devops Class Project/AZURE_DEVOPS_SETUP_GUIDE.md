# Azure DevOps CI/CD Pipeline Setup Guide
## House Price Prediction Application - Multi-Environment Deployment

---

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Phase 1: Azure DevOps Project Setup](#phase-1-azure-devops-project-setup)
3. [Phase 2: Docker Registry Configuration](#phase-2-docker-registry-configuration)
4. [Phase 3: Variable Groups Setup](#phase-3-variable-groups-setup)
5. [Phase 4: Environment Configuration](#phase-4-environment-configuration)
6. [Phase 5: Pipeline Setup](#phase-5-pipeline-setup)
7. [Phase 6: Approval Gates Configuration](#phase-6-approval-gates-configuration)
8. [Phase 7: Service Connections](#phase-7-service-connections)
9. [Phase 8: Testing & Validation](#phase-8-testing--validation)
10. [Troubleshooting](#troubleshooting)
11. [Monitoring & Maintenance](#monitoring--maintenance)

---

## Prerequisites

### Required Tools & Accounts
- [ ] Azure DevOps Organization (free tier available at https://dev.azure.com)
- [ ] Azure Container Registry (ACR) or Docker Hub account
- [ ] Git repository (Azure Repos or GitHub)
- [ ] Docker installed on agent machines
- [ ] Python 3.8+
- [ ] SonarQube Community Edition (optional but recommended)

### Required Permissions
- Project Administrator rights in Azure DevOps
- Docker registry write access
- Agent pool administration access

---

## Phase 1: Azure DevOps Project Setup

### Step 1: Create Azure DevOps Project

1. Go to https://dev.azure.com
2. Click **Create project**
3. Enter details:
   ```
   Project Name: House Price Prediction
   Description: CI/CD Pipeline for House Price Prediction ML Model
   Visibility: Private
   Version Control: Git
   Work item process: Agile
   ```
4. Click **Create**

### Step 2: Initialize Repository

```bash
# Clone the repository
git clone https://dev.azure.com/YOUR_ORG/House%20Price%20Prediction/_git/housepriceprediction
cd housepriceprediction

# Create branch structure
git checkout -b main
git checkout -b develop
git checkout -b feature/base-setup

# Create project structure
mkdir -p src tests pipelines docs
mkdir -p pipelines/ci-cd

# Copy the pipeline YAML
cp azure-devops-complete-pipeline.yml pipelines/ci-cd/

# Commit and push
git add .
git commit -m "Initial project structure"
git push --all origin
```

### Step 3: Create Required Folders

1. In Azure DevOps project:
   - **Repos** → Select your repository
   - Create folder structure:
     ```
     pipelines/
     ├── ci-cd/
     │   └── azure-pipelines.yml
     ├── stages/
     │   ├── build.yml
     │   ├── test.yml
     │   ├── deploy.yml
     │   └── production.yml
     docs/
     ├── pipeline-guide.md
     └── deployment-runbook.md
     ```

---

## Phase 2: Docker Registry Configuration

### Option A: Azure Container Registry (ACR)

#### Step 1: Create ACR in Azure Portal

```bash
# Create resource group
az group create \
  --name houseprice-rg \
  --location eastus

# Create container registry
az acr create \
  --resource-group houseprice-rg \
  --name housepriceprediction \
  --sku Basic \
  --admin-enabled true
```

#### Step 2: Get Registry Credentials

```bash
# Get login server
az acr show \
  --resource-group houseprice-rg \
  --name housepriceprediction \
  --query loginServer --output tsv

# Get credentials
az acr credential show \
  --resource-group houseprice-rg \
  --name housepriceprediction
```

Output example:
```
loginServer: housepriceprediction.azurecr.io
username: housepriceprediction
password: <YOUR_PASSWORD>
```

### Option B: Docker Hub

If using Docker Hub:
- Username: `your-dockerhub-username`
- Token: Create personal access token at https://hub.docker.com/settings/security

---

## Phase 3: Variable Groups Setup

### Step 1: Create Variable Groups

Navigate to: **Pipelines** → **Library** → **Variable groups**

#### Variable Group 1: Global Settings

Click **+ Variable group**

```
Name: Global-Variables
Description: Global variables for all stages

Variables:
┌─────────────────────────────────────────────────┐
│ Name                  │ Value                     │
├─────────────────────────────────────────────────┤
│ imageName             │ housepriceprediction      │
│ pythonVersion         │ 3.8                       │
│ SONARQUBE_URL         │ http://localhost:9000     │
│ SONARQUBE_PROJECT_KEY │ housepriceprediction      │
│ SONARQUBE_LOGIN       │ admin                     │
│ SONARQUBE_PASSWORD    │ admin                     │
│ FLASK_PORT            │ 5000                      │
│ SONARQUBE_PORT        │ 9000                      │
│ dockerRegistryUrl     │ housepriceprediction.a... │
└─────────────────────────────────────────────────┘
```

#### Variable Group 2: DEV Environment

```
Name: DEV-Variables
Description: DEV environment specific variables

Variables:
┌─────────────────────────────────────────────────┐
│ Name              │ Value                         │
├─────────────────────────────────────────────────┤
│ ENVIRONMENT       │ dev                           │
│ FLASK_PORT        │ 5001                          │
│ REPLICA_COUNT     │ 1                             │
│ LOG_LEVEL         │ DEBUG                         │
│ MAX_CONNECTIONS   │ 10                            │
│ DB_HOST           │ dev-db.internal               │
│ CACHE_ENABLED     │ false                         │
│ API_TIMEOUT       │ 30                            │
│ ENABLE_METRICS    │ true                          │
└─────────────────────────────────────────────────┘
```

#### Variable Group 3: QA Environment

```
Name: QA-Variables
Description: QA environment specific variables

Variables:
┌─────────────────────────────────────────────────┐
│ Name              │ Value                         │
├─────────────────────────────────────────────────┤
│ ENVIRONMENT       │ qa                            │
│ FLASK_PORT        │ 5002                          │
│ REPLICA_COUNT     │ 2                             │
│ LOG_LEVEL         │ INFO                          │
│ MAX_CONNECTIONS   │ 50                            │
│ DB_HOST           │ qa-db.internal                │
│ CACHE_ENABLED     │ true                          │
│ API_TIMEOUT       │ 60                            │
│ ENABLE_METRICS    │ true                          │
└─────────────────────────────────────────────────┘
```

#### Variable Group 4: UAT Environment

```
Name: UAT-Variables
Description: UAT environment specific variables

Variables:
┌─────────────────────────────────────────────────┐
│ Name              │ Value                         │
├─────────────────────────────────────────────────┤
│ ENVIRONMENT       │ uat                           │
│ FLASK_PORT        │ 5003                          │
│ REPLICA_COUNT     │ 2                             │
│ LOG_LEVEL         │ INFO                          │
│ MAX_CONNECTIONS   │ 100                           │
│ DB_HOST           │ uat-db.internal               │
│ CACHE_ENABLED     │ true                          │
│ API_TIMEOUT       │ 90                            │
│ ENABLE_METRICS    │ true                          │
│ REQUIRE_AUTH      │ true                          │
└─────────────────────────────────────────────────┘
```

#### Variable Group 5: PRODUCTION Environment

```
Name: PRODUCTION-Variables
Description: PRODUCTION environment specific variables (Mark as SECRET)

Variables:
┌─────────────────────────────────────────────────┐
│ Name              │ Value                         │
├─────────────────────────────────────────────────┤
│ ENVIRONMENT       │ production                    │
│ FLASK_PORT        │ 5000                          │
│ REPLICA_COUNT     │ 3                             │
│ LOG_LEVEL         │ WARNING                       │
│ MAX_CONNECTIONS   │ 500                           │
│ DB_HOST           │ prod-db.internal              │
│ CACHE_ENABLED     │ true                          │
│ API_TIMEOUT       │ 120                           │
│ ENABLE_METRICS    │ true                          │
│ REQUIRE_AUTH      │ true                          │
│ ENABLE_SSL        │ true                          │
│ DB_PASSWORD       │ *** (Mark as secret)          │
│ API_KEY           │ *** (Mark as secret)          │
└─────────────────────────────────────────────────┘
```

### Step 2: Mark Sensitive Variables

For PRODUCTION variables:
1. Click the lock icon next to sensitive values (passwords, API keys)
2. Check **Keep this value secret**
3. Value will be masked in logs

---

## Phase 4: Environment Configuration

### Step 1: Create Deployment Environments

Navigate to: **Pipelines** → **Environments**

#### Create DEV Environment

1. Click **Create environment**
   ```
   Name: DEV
   Description: Development Environment
   ```
2. Click **Create**

#### Create QA Environment

```
Name: QA
Description: Quality Assurance Environment
```

#### Create UAT Environment

```
Name: UAT
Description: User Acceptance Testing Environment
```

#### Create PRODUCTION Environment

```
Name: PRODUCTION
Description: Production Environment
```

### Step 2: Configure Environment Variables

For each environment:

1. Click the environment name
2. Click **... (more)** → **Variables**
3. Add environment-specific variables
4. Click **Save**

### Step 3: Environment Approvals Configuration

(See Phase 6 for detailed setup)

---

## Phase 5: Pipeline Setup

### Step 1: Create Pipeline in UI

Navigate to: **Pipelines** → **Pipelines**

1. Click **Create Pipeline**
2. Select repository location:
   ```
   Where is your code?
   → Azure Repos Git (or GitHub)
   ```
3. Select the repository:
   ```
   Select a repository
   → House Price Prediction
   ```
4. Configure pipeline:
   ```
   Configure your pipeline
   → Existing Azure Pipelines YAML file
   ```
5. Select YAML path:
   ```
   Path
   → pipelines/ci-cd/azure-pipelines.yml
   ```
6. Click **Continue**
7. Click **Save and run**

### Step 2: Update Pipeline YAML

Update the following values in your YAML file:

```yaml
# Line 18: Update docker registry connection
dockerRegistryServiceConnection: 'YOUR_REGISTRY_CONNECTION_NAME'

# Line 19: Update registry URL
dockerRegistryUrl: 'housepriceprediction.azurecr.io'

# If using GitHub instead of Azure Repos, add trigger:
trigger:
  branches:
    include:
    - main
    - develop
  paths:
    exclude:
    - docs/**
    - '*.md'
```

### Step 3: Configure Build Agent

Check agent capabilities:

Navigate to: **Project Settings** → **Agent pools** → **Default**

Ensure your agent has:
- Docker
- Python 3.8+
- Git
- curl

View logs: **Pipelines** → **Pipeline runs** → select run → **Agent diagnostics**

---

## Phase 6: Approval Gates Configuration

### Step 1: Configure Approval for UAT Deployment

Navigate to: **Pipelines** → **Environments** → **UAT**

1. Click the **... (menu)** next to the environment
2. Select **Approvals and checks**
3. Click **Create**
4. Select **Approvals**
5. Configure:
   ```
   Approvers:
   - qa-lead@yourdomain.com
   - qa-manager@yourdomain.com
   
   Instructions for approvers:
   "Please review QA test results and verify all test cases passed before approving UAT deployment"
   
   Timeout: 1 day
   On timeout: Reject
   ```

### Step 2: Configure Approval for PRODUCTION Deployment

Navigate to: **Pipelines** → **Environments** → **PRODUCTION**

1. Click the **... (menu)**
2. Select **Approvals and checks**
3. Click **Create**
4. Configure:
   ```
   Approvers:
   - devops-lead@yourdomain.com
   - prod-manager@yourdomain.com
   - tech-lead@yourdomain.com
   
   Instructions for approvers:
   "PRODUCTION DEPLOYMENT APPROVAL REQUIRED
   - All UAT tests must be passed
   - Performance benchmarks must be met
   - Security scan must show no critical issues
   - Rollback plan must be reviewed
   
   Contact: devops-team@yourdomain.com"
   
   Timeout: 4 hours
   On timeout: Reject
   
   Minimum number of approvers: 2
   ```

### Step 3: Add Business Hours Check (Optional)

1. Click **Create** again
2. Select **Business hours**
3. Configure:
   ```
   Time zone: Your timezone
   Start time: 09:00
   End time: 17:00
   Days: Monday-Friday
   ```

---

## Phase 7: Service Connections

### Step 1: Create Docker Registry Service Connection

Navigate to: **Project Settings** → **Service connections**

#### For Azure Container Registry (ACR):

1. Click **Create service connection**
2. Select **Docker Registry**
3. Configure:
   ```
   Docker Registry: Azure Container Registry
   Subscription: (select your subscription)
   Azure container registry: housepriceprediction
   Service connection name: ACR-Docker-Connection
   ```
4. Click **Save**

#### For Docker Hub:

1. Click **Create service connection**
2. Select **Docker Registry**
3. Configure:
   ```
   Docker Registry: Docker Hub
   Docker ID: your-dockerhub-username
   Docker Password: (personal access token)
   Email: your-email@domain.com
   Service connection name: DockerHub-Connection
   ```
4. Click **Save**

### Step 2: Create Azure Subscription Connection (if using Azure VMs)

1. Click **Create service connection**
2. Select **Azure Resource Manager**
3. Configure:
   ```
   Authentication method: Service principal (automatic)
   Subscription: (select your subscription)
   Service connection name: Azure-Subscription-Connection
   ```
4. Click **Save**

### Step 3: Update Pipeline with Service Connection Name

In your YAML file, update line 18:

```yaml
dockerRegistryServiceConnection: 'ACR-Docker-Connection'  # or 'DockerHub-Connection'
```

---

## Phase 8: Testing & Validation

### Step 1: Trigger First Pipeline Run

1. Go to **Pipelines** → **Pipelines**
2. Select your pipeline
3. Click **Run pipeline**
4. Configure:
   ```
   Branch: main
   Variables: (leave defaults)
   ```
5. Click **Run**

### Step 2: Monitor Pipeline Execution

Track each stage:

```
SetupSonarQube ✓
├─ Start SonarQube Container
│
SonarQubeSetup ✓
├─ Create SonarQube Project
│
Checkout ✓
├─ Get Source Code
│
CodeAnalysis ⏳
├─ Install SonarScanner
├─ Run SonarQube Analysis
└─ Export Report
│
SecurityScan ⏳
├─ Run Bandit Scan
└─ Run Safety Check
│
Build ⏳
├─ Build Docker Image
│
Test ⏳
├─ Run Unit Tests
├─ Publish Results
│
PerformanceTest ⏳
├─ Load Testing
│
PushToRegistry ⏳
├─ Push to Registry
│
DeployDev ⏳
├─ Deploy to DEV
│
DeployQA ⏳
├─ Deploy to QA
├─ QA Smoke Tests
│
DeployUAT ⏳ (Approval Required)
├─ Wait for Approval
│
DeployProduction ⏳ (Approval Required)
├─ Wait for Approval
└─ Deploy to Production
```

### Step 3: Verify Deployments

For each environment, verify:

```bash
# DEV Environment
curl http://localhost:5001/
docker ps | grep houseprice-dev
docker logs houseprice-dev

# QA Environment
curl http://localhost:5002/
docker ps | grep houseprice-qa
docker logs houseprice-qa

# UAT Environment
curl http://localhost:5003/
docker ps | grep houseprice-uat

# PRODUCTION Environment
curl http://localhost:5000/
docker ps | grep houseprice-prod
```

### Step 4: Check Artifacts

Navigate to: **Pipelines** → **Runs** → Select Run

Download artifacts:
- `test-reports`: JUnit test results, code coverage
- `security-reports`: Bandit and Safety scan results
- `perf-reports`: Performance test metrics
- `deployment-summary`: Deployment information

---

## Phase 9: Configure Notifications

### Step 1: Set up Email Notifications

Navigate to: **Project Settings** → **Notifications**

Create notification rules:

1. **Pipeline Failed**
   ```
   Trigger: Build pipeline completes
   Filter: State = Failed
   Recipients: devops-team@yourdomain.com
   ```

2. **Deployment Approval Required**
   ```
   Trigger: Approval pending
   Filter: Release = Deployment
   Recipients: approvers@yourdomain.com
   ```

### Step 2: Slack Integration (Optional)

1. Install Slack app in Azure DevOps
2. Configure channel notifications:
   ```
   #devops-ci-cd: Pipeline status updates
   #devops-approvals: Approval notifications
   ```

---

## Troubleshooting

### Issue 1: Docker Image Not Found in Registry

**Error Message:**
```
docker pull: failed to resolve reference
```

**Solution:**
```bash
# Verify image was pushed
az acr repository list --name housepriceprediction

# Check image tags
az acr repository show-tags --name housepriceprediction --repository housepriceprediction

# Manually push if needed
docker tag housepriceprediction:latest housepriceprediction.azurecr.io/housepriceprediction:latest
docker push housepriceprediction.azurecr.io/housepriceprediction:latest
```

### Issue 2: SonarQube Connection Timeout

**Error Message:**
```
Failed to connect to SonarQube at http://localhost:9000
```

**Solution:**
```bash
# Check if SonarQube is running
docker ps | grep sonarqube

# Restart SonarQube
docker rm -f sonarqube
docker run -d --name sonarqube -p 9000:9000 sonarqube:community

# Wait for startup
sleep 30

# Test connection
curl http://localhost:9000/api/system/status
```

### Issue 3: Approval Gate Not Triggered

**Solution:**
1. Verify environment was selected in deployment job:
   ```yaml
   - deployment: DeployUATJob
     environment:
       name: 'UAT'  # Must match environment name
   ```

2. Check approvers are members of project:
   - **Project Settings** → **Members**
   - Add approvers as project members

3. Verify approval check is enabled:
   - **Pipelines** → **Environments** → **UAT**
   - Click **... → Approvals and checks**
   - Verify approval exists

### Issue 4: Container Port Already in Use

**Error Message:**
```
docker: Error response from daemon: Ports are not available
```

**Solution:**
```bash
# Find process using port
sudo lsof -i :5001

# Kill process
kill -9 <PID>

# Or change port in variable group and redeploy
```

### Issue 5: Pipeline Timeout

**Issue:**
Pipeline exceeds default 60-minute timeout

**Solution:**
Add timeout configuration in YAML:
```yaml
stages:
- stage: StageName
  displayName: 'Stage Display Name'
  timeoutInMinutes: 120  # Increase timeout
```

---

## Monitoring & Maintenance

### Step 1: Pipeline Analytics

Navigate to: **Pipelines** → **Pipelines** → Select Pipeline → **Analytics**

Monitor:
- Pass rate
- Average duration
- Failure reasons
- Stage-wise performance

### Step 2: Deployment Dashboard

Create dashboard:

1. **Azure DevOps** → **Dashboards**
2. Click **Create dashboard**
3. Add widgets:
   - Deployment status
   - Build history
   - Release summary
   - Test results

### Step 3: Regular Maintenance

**Weekly Tasks:**
- [ ] Review pipeline logs for warnings
- [ ] Check security scan results
- [ ] Verify all deployments succeeded
- [ ] Review artifact storage usage

**Monthly Tasks:**
- [ ] Update agent images
- [ ] Review and update variable groups
- [ ] Audit service connections
- [ ] Performance optimization review

**Quarterly Tasks:**
- [ ] Update container base images
- [ ] Security dependencies update
- [ ] Capacity planning review
- [ ] Disaster recovery drill

### Step 4: Enable Diagnostics Logging

In pipeline YAML, add at start:

```yaml
variables:
  system.debug: false  # Set to true for troubleshooting
  PIPELINE_DEBUG: false

# For troubleshooting, use:
# - script: |
#     set -x  # Enable bash debug mode
#     <your command>
#   displayName: 'Debug Step'
```

---

## Quick Reference Commands

### Local Testing

```bash
# Build Docker image locally
docker build -t housepriceprediction:local .

# Run container
docker run -d --name test-app -p 5000:5000 housepriceprediction:local

# Check logs
docker logs test-app

# Test endpoints
curl http://localhost:5000/

# Stop container
docker stop test-app
docker rm test-app
```

### Azure CLI Commands

```bash
# List pipelines
az pipelines list --project "House Price Prediction"

# Get pipeline details
az pipelines show --id <PIPELINE_ID>

# Trigger pipeline run
az pipelines run --id <PIPELINE_ID> --branch main

# Get run status
az pipelines runs list --pipeline-ids <PIPELINE_ID>

# Get run details
az pipelines runs show --id <RUN_ID> --project "House Price Prediction"
```

### Docker Registry Commands

```bash
# Login to ACR
az acr login --name housepriceprediction

# List repositories
az acr repository list --name housepriceprediction

# List tags
az acr repository show-tags --name housepriceprediction --repository housepriceprediction

# Delete image
az acr repository delete --name housepriceprediction --image housepriceprediction:TAG
```

---

## Next Steps

1. **Custom Stages**: Add environment-specific deployment scripts
2. **Integration**: Connect with Kubernetes for orchestration
3. **Advanced Monitoring**: Setup Application Insights integration
4. **Advanced Security**: Add container scanning with Trivy
5. **IaC**: Use Terraform for infrastructure as code

---

## Support & Documentation

- [Azure Pipelines Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/)
- [Docker Documentation](https://docs.docker.com/)
- [SonarQube Documentation](https://docs.sonarqube.org/)

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2024 | DevOps Team | Initial release - Multi-environment setup |

---

**Last Updated**: 2024
**Document Status**: Active
