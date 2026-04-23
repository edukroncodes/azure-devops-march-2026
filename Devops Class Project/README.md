# House Price Prediction - Complete CI/CD Pipeline Documentation
## Quick Start Guide & Project Index

---

## 📚 Documentation Structure

```
Project Root/
├── pipelines/
│   └── ci-cd/
│       └── azure-pipelines.yml          [Complete pipeline YAML]
│
├── docker/
│   ├── Dockerfile                       [Multi-stage Docker build]
│   └── docker-compose.yml               [Local dev environment]
│
├── config/
│   └── environment-configs/
│       ├── .env.dev                     [DEV configuration]
│       ├── .env.qa                      [QA configuration]
│       ├── .env.uat                     [UAT configuration]
│       └── .env.production              [PRODUCTION configuration]
│
└── docs/
    ├── AZURE_DEVOPS_SETUP_GUIDE.md      [Step-by-step setup]
    ├── DEPLOYMENT_RUNBOOK.md            [Operational procedures]
    ├── ENVIRONMENT_CONFIGS.md           [Config details]
    └── README.md                        [This file]
```

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Prerequisites Check

```bash
# Verify required tools
docker --version          # Docker installed
git --version            # Git installed
python --version         # Python 3.8+
curl --version          # cURL installed

# Expected output:
# Docker version 20.10+
# git version 2.30+
# Python 3.8+
# curl 7.70+
```

### Step 2: Clone & Setup Repository

```bash
# Clone repository
git clone https://dev.azure.com/YOUR_ORG/House%20Price%20Prediction/_git/housepriceprediction
cd housepriceprediction

# Create branch structure
git checkout -b main

# Copy environment file
cp config/environment-configs/.env.dev .env

# Install dependencies (local testing)
pip install -r requirements.txt
```

### Step 3: Start Local Development Environment

```bash
# Start all services (Docker required)
docker-compose up -d

# Verify services
docker ps

# Expected containers:
# - sonarqube (port 9000)
# - postgres (port 5432)
# - redis (port 6379)
# - app-dev (port 5001)
# - app-qa (port 5002)
# - app-uat (port 5003)

# Test application
curl http://localhost:5001/
# Expected: 200 OK
```

### Step 4: Create Pipeline in Azure DevOps

```
1. Go to https://dev.azure.com
2. Create new project: "House Price Prediction"
3. Push code to repository
4. Pipelines → Create new → Select YAML
5. Point to: pipelines/ci-cd/azure-pipelines.yml
6. Click "Run"
```

---

## 📋 Complete Documentation Guide

### 1. **AZURE_DEVOPS_SETUP_GUIDE.md** 
   **Purpose**: Step-by-step setup instructions for Azure DevOps
   
   **Contains**:
   - Prerequisites and account setup
   - Project creation and repository setup
   - Docker registry configuration (ACR & Docker Hub)
   - Variable groups for each environment
   - Environment creation and configuration
   - Service connections setup
   - Pipeline creation and configuration
   - Approval gates configuration
   - Testing and validation procedures
   - Troubleshooting guide
   - Monitoring and maintenance
   
   **When to Use**: Initial setup and ongoing Azure DevOps administration
   
   **Key Sections**:
   - Phase 1-9: Complete setup walkthrough
   - Phase 6: Approval gates (critical for UAT/PROD)
   - Troubleshooting: Common issues and solutions

### 2. **azure-devops-complete-pipeline.yml**
   **Purpose**: Complete CI/CD pipeline definition
   
   **Contains**:
   - 15 stages from source code to production
   - Automated stages: Build, Test, Security, Deploy to Dev/QA
   - Manual approval stages: UAT, Production
   - Health checks and smoke tests
   - Performance testing
   - Code quality analysis (SonarQube)
   - Security scanning (Bandit, Safety)
   - Docker image building and pushing
   - Multi-environment deployments
   - Monitoring setup
   
   **Key Stages**:
   ```
   1.  SetupSonarQube
   2.  SonarQubeSetup
   3.  Checkout
   4.  CodeAnalysis
   5.  SecurityScan
   6.  Build
   7.  Test
   8.  PerformanceTest
   9.  PushToRegistry
   10. DeployDev (Automatic)
   11. DeployQA (Automatic)
   12. DeployUAT (Manual Approval)
   13. DeployProduction (Manual Approval + 2 Approvers)
   14. MonitoringSetup
   15. Cleanup
   ```
   
   **When to Use**: Place in `pipelines/ci-cd/azure-pipelines.yml` in your repository

### 3. **DEPLOYMENT_RUNBOOK.md**
   **Purpose**: Operational procedures for all environments
   
   **Contains**:
   - Pre-deployment checklist
   - DEV deployment procedures
   - QA deployment procedures
   - UAT deployment procedures (with approvals)
   - PRODUCTION deployment procedures (critical)
   - Rollback procedures for all environments
   - Incident response guide
   - Post-deployment verification
   - Monitoring procedures
   - Emergency procedures
   
   **Critical Sections**:
   - Production deployment (requires careful planning)
   - Rollback procedures (for emergency situations)
   - Incident response (escalation and recovery)
   
   **When to Use**: Daily operations, deployments, troubleshooting

### 4. **Dockerfile**
   **Purpose**: Docker image definition for the application
   
   **Features**:
   - Multi-stage build (smaller final image)
   - Python 3.8 slim base image
   - Non-root user for security
   - Health checks configured
   - Environment variables set
   - Proper working directory structure
   
   **When to Use**: Build Docker images for all environments

### 5. **docker-compose.yml**
   **Purpose**: Local development and testing environment
   
   **Services**:
   - SonarQube (code analysis)
   - PostgreSQL (database)
   - Redis (caching)
   - 3x Application instances (Dev, QA, UAT)
   - Prometheus (monitoring)
   - Grafana (visualization)
   
   **When to Use**: Local development and pre-pipeline testing

### 6. **requirements.txt**
   **Purpose**: Python dependencies for the application
   
   **Contains**:
   - Flask and web framework
   - Data processing (pandas, numpy, scikit-learn)
   - Database ORM (SQLAlchemy)
   - Caching (Redis)
   - Testing frameworks (pytest)
   - Code quality tools (black, flake8, pylint)
   - Security tools (bandit, safety)
   - Monitoring and logging
   
   **When to Use**: Install dependencies with `pip install -r requirements.txt`

### 7. **ENVIRONMENT_CONFIGS.md**
   **Purpose**: Configuration templates for all environments
   
   **Contains**:
   - `.env.dev`: Development environment variables
   - `.env.qa`: QA environment variables
   - `.env.uat`: UAT environment variables
   - `.env.production`: Production environment variables
   
   **Key Variables**:
   - Flask configuration
   - Database URLs
   - Redis configuration
   - API settings
   - Security settings
   - Monitoring settings
   
   **When to Use**: Create environment-specific `.env` files

---

## 🔄 Deployment Flow

### Typical Deployment Path

```
Developer Push to Main Branch
         ↓
    CI Pipeline Starts
    ├─ SonarQube Analysis
    ├─ Security Scanning
    ├─ Unit Tests & Coverage
    ├─ Build Docker Image
    └─ Performance Testing
         ↓
    Image Pushed to Registry
         ↓
    Automatic → DEV Deployment (5001)
         ↓
    Automatic → QA Deployment (5002)
    ├─ Smoke Tests
    └─ Performance Baseline
         ↓
    Manual Approval → UAT Deployment (5003)
    ├─ Business Testing
    ├─ UAT Verification
    └─ Sign-off Required
         ↓
    Manual Approval (2+ approvers) → PRODUCTION (5000)
    ├─ Backup Current
    ├─ Graceful Shutdown
    ├─ Deploy New Version
    ├─ Health Checks
    └─ Smoke Tests
         ↓
    24-Hour Monitoring & Sign-off
         ↓
    Deployment Complete ✓
```

---

## 📊 Environment Specifications

### DEV Environment
- **Port**: 5001
- **Auto Deploy**: Yes
- **Approval**: No
- **Replicas**: 1
- **Log Level**: DEBUG
- **Use Case**: Developer testing

### QA Environment
- **Port**: 5002
- **Auto Deploy**: Yes
- **Approval**: No
- **Replicas**: 2
- **Log Level**: INFO
- **Use Case**: Quality assurance testing

### UAT Environment
- **Port**: 5003
- **Auto Deploy**: No
- **Approval**: 1 approver required
- **Replicas**: 2
- **Log Level**: INFO
- **Use Case**: Business user testing

### PRODUCTION Environment
- **Port**: 5000
- **Auto Deploy**: No
- **Approval**: 2+ approvers required
- **Replicas**: 3
- **Log Level**: WARNING
- **Use Case**: Live production system

---

## ⚡ Essential Azure DevOps Setup Steps

### Step 1: Create Variable Groups (15 minutes)

Navigate to: **Pipelines** → **Library** → **Variable groups**

Create 5 variable groups:
1. **Global-Variables**: Common settings
2. **DEV-Variables**: Development settings
3. **QA-Variables**: QA settings
4. **UAT-Variables**: UAT settings
5. **PRODUCTION-Variables**: Production settings (mark sensitive vars as secret)

### Step 2: Create Environments (10 minutes)

Navigate to: **Pipelines** → **Environments**

Create 4 environments:
1. **DEV**: Development environment
2. **QA**: Quality assurance
3. **UAT**: User acceptance testing (add approval check)
4. **PRODUCTION**: Production (add 2-approver gate)

### Step 3: Create Service Connections (10 minutes)

Navigate to: **Project Settings** → **Service connections**

Create connections:
1. **Docker Registry**: ACR or Docker Hub
2. **Azure Subscription**: For Azure resources (optional)

### Step 4: Create Pipeline (5 minutes)

1. **Pipelines** → **Create Pipeline**
2. Select repository
3. Select **Existing Azure Pipelines YAML file**
4. Path: `pipelines/ci-cd/azure-pipelines.yml`
5. Click **Save and run**

### Step 5: Configure Approvals (10 minutes)

For **UAT Environment**:
- Set approvers: QA team leads
- Timeout: 1 day
- On timeout: Reject

For **PRODUCTION Environment**:
- Set approvers: Engineering manager, DevOps lead, Tech lead
- Minimum approvers: 2
- Timeout: 4 hours
- On timeout: Reject

---

## 🔧 Troubleshooting Quick Reference

### Build Fails
**Check**:
1. Python dependencies missing: `pip install -r requirements.txt`
2. Docker not installed: Install Docker Desktop
3. Dockerfile path wrong: Verify in pipeline YAML

### Tests Failing
**Steps**:
```bash
pytest tests/ -v
pytest tests/ --cov=.
```

**Common Issues**:
- Database not running: `docker-compose up postgres`
- Redis not available: `docker-compose up redis`
- Missing test data: Check fixtures

### Deployment Stuck
**Solution**:
```bash
# Check agent status
# Azure DevOps → Project Settings → Agent pools
# Verify agent has Docker, Python, etc.

# Check logs
# Pipelines → Runs → Select run → View logs
```

### Service Connection Error
**Fix**:
1. **Project Settings** → **Service connections**
2. Click the connection → **Edit**
3. Re-enter credentials
4. Test connection
5. **Save**

---

## 📞 Getting Help

### Documentation Files
- **General Setup**: See `AZURE_DEVOPS_SETUP_GUIDE.md`
- **Running Deployments**: See `DEPLOYMENT_RUNBOOK.md`
- **Configuration**: See `ENVIRONMENT_CONFIGS.md`
- **Troubleshooting**: See section in each guide

### Common Commands

```bash
# View pipeline runs
az pipelines runs list --project "House Price Prediction"

# Trigger pipeline
az pipelines run --id <PIPELINE_ID> --branch main

# View run logs
az pipelines runs show --id <RUN_ID>

# Check Docker status
docker ps -a
docker logs <CONTAINER_NAME>

# Test application
curl http://localhost:5001/
curl http://localhost:5002/
curl http://localhost:5003/
curl http://localhost:5000/
```

---

## ✅ Success Criteria

### Pipeline Execution Success

- [ ] All 15 stages complete successfully
- [ ] Build time < 30 minutes
- [ ] Test coverage > 80%
- [ ] Security scan: 0 critical issues
- [ ] All environments deploy successfully
- [ ] Health checks pass on all ports
- [ ] No errors in container logs

### Deployment Success

- [ ] Container starts and is healthy
- [ ] Application responds to requests
- [ ] Database connectivity verified
- [ ] Performance baselines met
- [ ] No error spikes
- [ ] Monitoring active and alerts configured
- [ ] Stakeholders notified

---

## 🎯 Next Steps After Setup

1. **Week 1**: Setup Azure DevOps and run first pipeline
2. **Week 2**: Configure all environments and variable groups
3. **Week 3**: Setup approval gates and test end-to-end
4. **Week 4**: Train team on deployment procedures
5. **Month 2**: Monitor, optimize, and refine processes

---

## 📈 Performance Targets

| Metric | DEV | QA | UAT | PROD |
|--------|-----|-----|-----|------|
| Response Time (p95) | < 100ms | < 100ms | < 200ms | < 200ms |
| Availability | 99% | 99.5% | 99.9% | 99.99% |
| Error Rate | < 0.5% | < 0.1% | < 0.05% | < 0.01% |
| Build Time | < 30 min | < 30 min | < 30 min | < 30 min |
| Deploy Time | < 5 min | < 5 min | < 10 min | < 15 min |

---

## 📝 Deployment Approval Requirements

### UAT Deployment
```
Approvers Required: 1
Approval Timeout: 1 day
Required Info:
  ✓ All QA tests passed
  ✓ Performance metrics acceptable
  ✓ Change log updated
  ✓ Business requirements verified
```

### PRODUCTION Deployment
```
Approvers Required: 2 (minimum)
Approval Timeout: 4 hours
Required Approvers:
  ✓ Engineering Manager
  ✓ DevOps Lead
  ✓ Technical Lead (any 2 of 3+)

Required Info:
  ✓ UAT sign-off completed
  ✓ All tests passing
  ✓ Security scan clean
  ✓ Performance tested
  ✓ Rollback plan reviewed
  ✓ Backup verified
  ✓ Incident response ready
```

---

## 🔐 Security Checklist

- [ ] No hardcoded secrets in code
- [ ] Docker image scanned for vulnerabilities
- [ ] Database passwords secured (in variable groups, marked as secret)
- [ ] API keys and tokens in secret management
- [ ] HTTPS enabled in production
- [ ] Authentication enabled for sensitive operations
- [ ] CORS properly configured per environment
- [ ] Rate limiting enabled
- [ ] Logging configured for audit trail
- [ ] Regular security updates applied

---

## 📞 Support & Contact

**For Setup Help**: See `AZURE_DEVOPS_SETUP_GUIDE.md`
**For Deployment Issues**: See `DEPLOYMENT_RUNBOOK.md`
**For Configuration**: See `ENVIRONMENT_CONFIGS.md`

---

## 📚 Document Versions

| Document | Version | Last Updated | Status |
|----------|---------|--------------|--------|
| Pipeline YAML | 1.0 | 2024 | Active |
| Setup Guide | 1.0 | 2024 | Active |
| Runbook | 1.0 | 2024 | Active |
| Dockerfile | 1.0 | 2024 | Active |
| Docker Compose | 1.0 | 2024 | Active |
| Requirements | 1.0 | 2024 | Active |

---

## 🎓 Learning Resources

- [Azure Pipelines Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [Docker Documentation](https://docs.docker.com/)
- [SonarQube Documentation](https://docs.sonarqube.org/)
- [Kubernetes Documentation](https://kubernetes.io/docs/) (for future K8s integration)

---

**Created**: 2024
**Last Updated**: 2024
**Maintained By**: DevOps Team
**Status**: ✅ Production Ready

**Ready to deploy? Start with the [AZURE_DEVOPS_SETUP_GUIDE.md](./AZURE_DEVOPS_SETUP_GUIDE.md)**
