# House Price Prediction - Deployment Runbook
## Complete Guide to Managing Deployments Across All Environments

---

## 📑 Table of Contents
1. [Deployment Overview](#deployment-overview)
2. [Pre-Deployment Checklist](#pre-deployment-checklist)
3. [DEV Environment Deployment](#dev-environment-deployment)
4. [QA Environment Deployment](#qa-environment-deployment)
5. [UAT Environment Deployment](#uat-environment-deployment)
6. [PRODUCTION Environment Deployment](#production-environment-deployment)
7. [Rollback Procedures](#rollback-procedures)
8. [Incident Response](#incident-response)
9. [Post-Deployment Verification](#post-deployment-verification)
10. [Monitoring After Deployment](#monitoring-after-deployment)
11. [Emergency Procedures](#emergency-procedures)

---

## Deployment Overview

### Environment Progression Path

```
Main Branch Push
       ↓
   CI Pipeline
       ↓
 SetupSonarQube
       ↓
 CodeAnalysis
       ↓
 SecurityScan
       ↓
 Build Docker Image
       ↓
 Unit & Integration Tests
       ↓
 Performance Testing
       ↓
 Push to Registry
       ↓
 DEV Deployment (Automatic)
       ↓
 QA Deployment (Automatic)
       ↓
 UAT Deployment (Manual Approval Required)
       ↓
 PRODUCTION Deployment (Manual Approval + 2+ Approvers)
```

### Deployment Timeline Estimates

| Environment | Automated | Duration | Approval Required |
|-------------|-----------|----------|-------------------|
| DEV         | Yes       | 15 min   | No                |
| QA          | Yes       | 15 min   | No                |
| UAT         | No        | 20 min   | Yes (1 approver)  |
| PRODUCTION  | No        | 25 min   | Yes (2+ approvers)|

---

## Pre-Deployment Checklist

### Before Triggering Any Deployment

- [ ] **Code Review Complete**
  - All code has been reviewed by at least one team member
  - No unresolved review comments
  
- [ ] **Tests Passing**
  ```bash
  # Verify locally
  pytest tests/ -v --cov
  
  # Expected: All tests pass
  # Expected: Coverage > 80%
  ```

- [ ] **Security Scan Complete**
  ```bash
  # Run security checks
  bandit -r . -f json -o bandit-report.json
  safety check --json > safety-report.json
  
  # Expected: No critical vulnerabilities
  ```

- [ ] **Performance Metrics Acceptable**
  ```bash
  # Response time < 100ms for DEV/QA
  # Response time < 200ms for UAT/PROD
  # Throughput > 100 req/sec
  ```

- [ ] **Database Migrations Complete**
  ```bash
  # Verify migrations
  alembic current
  
  # Expected: Latest migration applied
  ```

- [ ] **Environment Variables Updated**
  - All required variables set
  - No hardcoded secrets in code
  - .env files updated for each environment

- [ ] **Documentation Updated**
  - API documentation current
  - Change log updated
  - Deployment notes prepared

- [ ] **Stakeholders Notified**
  - Team notified of upcoming deployment
  - Business owners aware of timeline
  - Support team briefed on changes

---

## DEV Environment Deployment

### Overview
- **Frequency**: Every commit to main branch
- **Duration**: ~15 minutes
- **Downtime**: None (always available)
- **Approval**: Automatic
- **Rollback**: Automatic on failure

### Step 1: Trigger Pipeline (Automatic)

```bash
# Deployment is triggered automatically when code is pushed
git push origin main

# Monitor in Azure DevOps
# Pipelines → Pipelines → House Price Prediction → Select latest run
```

### Step 2: Monitor Pipeline Execution

```
Expected Stages:
✓ SetupSonarQube
✓ CodeAnalysis
✓ SecurityScan
✓ Build
✓ Test
✓ PerformanceTest
✓ PushToRegistry
→ DeployDev (Current)
```

Watch for:
- Build status: **Success**
- Test coverage: **> 80%**
- Security issues: **None critical**

### Step 3: Verify DEV Deployment

```bash
# Check if container is running
docker ps | grep houseprice-dev

# Expected output:
# housepriceprediction  houseprice-dev  Up 2 minutes  0.0.0.0:5001->5000/tcp

# Test health endpoint
curl http://localhost:5001/
# Expected: 200 OK

# Check application logs
docker logs houseprice-dev --tail 50

# Expected: No error messages
```

### Step 4: Run Smoke Tests

```bash
# Basic API test
curl -s http://localhost:5001/ | grep -i "success" || echo "FAILED"

# Test a model prediction endpoint (if available)
curl -X POST http://localhost:5001/api/predict \
  -H "Content-Type: application/json" \
  -d '{"features": [2.5, 3.0, 1500]}'

# Expected: 200 OK with prediction result
```

### Step 5: Notify Team

```bash
# Post to Slack/Teams
📢 DEV Deployment Successful
- Build #1234
- Status: Success ✅
- Duration: 15 minutes
- Deployed by: Auto CI Pipeline
```

### Troubleshooting DEV Deployment

**Issue: Deployment Stage Stuck**
```bash
# Check logs
docker logs houseprice-dev

# Common cause: Port already in use
lsof -i :5001
kill -9 <PID>

# Restart manually
docker rm -f houseprice-dev
docker run -d --name houseprice-dev -p 5001:5000 \
  housepriceprediction:latest
```

**Issue: Container Fails Health Check**
```bash
# Check health
docker inspect houseprice-dev | grep -A 5 Health

# Review logs for errors
docker logs houseprice-dev

# Common causes:
# 1. Wrong environment variables
# 2. Database not accessible
# 3. Missing dependencies
```

---

## QA Environment Deployment

### Overview
- **Frequency**: After successful DEV deployment
- **Duration**: ~15 minutes
- **Downtime**: None
- **Approval**: Automatic
- **Scope**: Full integration testing

### Step 1: Monitor QA Deployment

```
Expected Flow:
1. DEV Deployment succeeds
2. Automatic trigger of QA deployment
3. Wait for health checks to pass
4. Smoke tests run automatically
```

### Step 2: Verify QA Deployment

```bash
# List running containers
docker ps | grep -E "houseprice-(qa|prod|uat|dev)"

# Get specific container status
docker inspect houseprice-qa | grep -E '"Status"|"RestartCount"'

# Test endpoints
curl http://localhost:5002/health
# Expected: 200 OK

# Check container stats
docker stats houseprice-qa --no-stream
# Expected: CPU < 10%, Memory < 500MB
```

### Step 3: Run QA Smoke Tests

Automated tests run as part of pipeline:

```bash
# Manually run smoke tests if needed
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:5002/

# Expected: 200

# Test multiple endpoints
for endpoint in / /health /api/status; do
  curl -s "http://localhost:5002$endpoint" > /dev/null
  echo "Endpoint $endpoint: OK"
done
```

### Step 4: Performance Validation

```bash
# Run Apache Bench load test
ab -n 100 -c 10 http://localhost:5002/

# Expected results:
# - Requests per second: > 50
# - Failed requests: 0
# - Time per request: < 100ms
```

### Step 5: QA Sign-off

```bash
# Log results
cat > qa-deployment-report.txt << EOF
QA Deployment Report
====================
Build: #1234
Timestamp: $(date)
Status: PASSED

Tests:
✓ Health checks passed
✓ API endpoints responsive
✓ Performance baseline met
✓ No error logs
✓ Container stats healthy

Approved for UAT
EOF

# Share with QA team
```

### QA Deployment Issues

**Issue: Smoke Tests Failing**

```bash
# Check container logs for errors
docker logs houseprice-qa --since 5m

# Verify environment variables
docker inspect houseprice-qa | grep -A 20 "Env"

# Verify database connectivity
docker exec houseprice-qa curl http://postgres:5432/

# Restart if needed
docker restart houseprice-qa
```

---

## UAT Environment Deployment

### Overview
- **Frequency**: On-demand (manual trigger)
- **Duration**: ~20 minutes
- **Downtime**: Brief (5-10 seconds)
- **Approval**: Required (1+ approvers)
- **Scope**: User acceptance testing, business validation

### Step 1: Request UAT Deployment

```bash
# Go to Azure DevOps
# Pipelines → House Price Prediction → Select latest run

# When DeployUAT stage reaches approval:
# Click "Review" button
```

### Step 2: Approve Deployment

**Approver Checklist**:
- [ ] All QA tests passed
- [ ] No critical security issues
- [ ] Performance metrics acceptable
- [ ] Change log reviewed
- [ ] Business requirements verified
- [ ] Rollback plan understood

**In Azure DevOps**:
1. Click **Approve** button
2. Add comment: "UAT approved - all criteria met"
3. Confirm approval

### Step 3: Monitor UAT Deployment

```
Expected Timeline:
0:00 - Approval confirmed
0:05 - Container started
0:10 - Health checks running
0:15 - Smoke tests pass
0:20 - Deployment complete
```

Watch deployment logs:
```bash
# In Azure DevOps, watch the logs
# Look for:
# ✓ Container started successfully
# ✓ Health checks passed
# ✓ No error messages in logs
# ✓ Deployment verified
```

### Step 4: Verify UAT Deployment

```bash
# SSH to UAT server
ssh uat-server.yourdomain.com

# Check container
docker ps | grep houseprice-uat

# Test application
curl -s http://localhost:5003/ | head -20

# Check logs
docker logs houseprice-uat --tail 30

# Monitor resources
docker stats houseprice-uat --no-stream

# Database connectivity test
docker exec houseprice-uat curl http://postgres:5432/

# Expected: All healthy
```

### Step 5: Run UAT Tests

```bash
# Performance baseline
ab -n 100 -c 10 http://localhost:5003/
# Expected: > 50 req/sec, 0 failures

# Comprehensive API tests
curl -X POST http://localhost:5003/api/predict \
  -H "Content-Type: application/json" \
  -d '{
    "square_feet": 2500,
    "bedrooms": 4,
    "bathrooms": 2.5,
    "age_years": 10
  }'
# Expected: Prediction result with confidence score

# Data validation
curl http://localhost:5003/api/model/info
# Expected: Model metadata and version
```

### Step 6: Business User Testing

Notify business stakeholders:

```
📢 UAT Environment Ready for Testing
- Build: #1234
- Deployment Time: 2024-XX-XX 10:30 AM
- URL: https://uat.yourdomain.com
- Credentials: [Provided separately]

Testing Duration: 2-5 business days
Expected Sign-off: [Date]
```

### UAT Deployment Rollback

If critical issues found during UAT:

```bash
# IMMEDIATE: Notify DevOps team
# Contact: devops-team@yourdomain.com

# IMMEDIATE: Switch to previous version
docker stop houseprice-uat
docker run -d --name houseprice-uat -p 5003:5000 \
  housepriceprediction:PREVIOUS-BUILD-NUMBER

# Document issue
cat > uat-incident.txt << EOF
UAT Deployment Issue
===================
Build: #1234
Time Detected: [Time]
Issue: [Description]
Root Cause: [Analysis]
Action Taken: Rolled back to #1233

Post-Incident Review: [Date/Time]
EOF
```

---

## PRODUCTION Environment Deployment

### Overview
- **Frequency**: Weekly or as needed
- **Duration**: ~25 minutes
- **Downtime**: None (zero-downtime deployment)
- **Approval**: Required (2+ approvers, 4-hour window)
- **Scope**: Live production environment
- **Criticality**: **HIGHEST**

### Pre-Production Deployment Verification (24 Hours Before)

```bash
# 1. Verify backup strategy
echo "Recent backups:"
ls -lh /backups/prod/

# 2. Check current production status
docker ps | grep houseprice-prod
docker stats houseprice-prod --no-stream

# 3. Review change log
cat CHANGELOG.md | head -30

# 4. Verify rollback procedure is documented
grep -i "rollback" DEPLOYMENT_RUNBOOK.md

# 5. Notify production support team
echo "Production deployment scheduled for [DATE/TIME]
   Change Description: [Summary]
   Expected Duration: 25 minutes
   Rollback Plan: [Reference]"
```

### Step 1: Create Production Backup (T-5 Minutes)

```bash
# SSH to production server
ssh prod-server.yourdomain.com

# Create database backup
pg_dump houseprice_db > /backups/prod/houseprice_db_$(date +%Y%m%d_%H%M%S).sql

# Verify backup size
ls -lh /backups/prod/houseprice_db_*.sql | tail -1

# Create docker image backup
docker commit houseprice-prod houseprice-prod:backup-$(date +%s)

# Verify backup created
docker images | grep houseprice-prod | head -3

# Expected: Recent backup file created, > 100MB for database
```

### Step 2: Request Production Approval

In Azure DevOps:

1. Go to **Pipelines** → Select run
2. When **DeployProduction** stage shows approval notification
3. Click **Review** button

**Approval Form**:

```
Deployment Information
======================
Build Number: [#####]
Source Commit: [SHA-1]
Change Description: [Summary]
Business Owner: [Name]
Technical Lead: [Name]

Approval Checklist
==================
☐ Code review completed and approved
☐ All tests passing (test coverage > 80%)
☐ Security scan clean (no critical vulnerabilities)
☐ Performance metrics acceptable
☐ Database migrations tested
☐ Rollback plan reviewed and understood
☐ Stakeholders notified
☐ Monitoring alerts configured
☐ Support team briefed
☐ Backup verified
☐ Maintenance window scheduled (if needed)
☐ Customer impact assessed

Approver Name: _____________________
Approver Email: _____________________
Date & Time: _____________________
Comments/Notes: _____________________
```

### Step 3: Wait for Second Approver

**Requirement**: Minimum 2 approvers required

- First approver: Technical lead or DevOps engineer
- Second approver: Engineering manager or product owner

```bash
# Check approval status
# In Azure DevOps, you'll see approver list and status

# Expected: Shows "Waiting for approval from X of 2 approvers"
```

### Step 4: Monitor Production Deployment (T+0)

**Timeline**:

```
T+0:00  - Second approval received
T+0:05  - Pre-deployment backup created
T+0:10  - Old container gracefully stopped
T+0:15  - New container started
T+0:20  - Health checks running
T+0:25  - Deployment complete and verified
```

**Monitor in Azure DevOps**:

```bash
# Live log view
Pipelines → Runs → [Current Run] → Deploy stage logs

# Watch for:
✓ Creating backup of current production
✓ Gracefully stopping old container
✓ Pulling new image from registry
✓ Starting new container
✓ Health checks: PASS
✓ Deployment verified successfully
```

### Step 5: Post-Deployment Verification (T+5)

```bash
# SSH to production server
ssh prod-server.yourdomain.com

# Check container status
docker ps | grep houseprice-prod
# Expected: Running, fresh start time

# Verify application responsiveness
curl http://localhost:5000/
# Expected: 200 OK

# Check application logs for errors
docker logs houseprice-prod --since 5m
# Expected: No error messages

# Performance check
curl -w "Response Time: %{time_total}s\n" http://localhost:5000/
# Expected: < 100ms

# Database connectivity
docker exec houseprice-prod \
  curl -s http://postgres:5432/ > /dev/null
# Expected: 0 (connection established)

# Memory usage check
docker stats houseprice-prod --no-stream
# Expected: Memory < 1GB
```

### Step 6: Smoke Tests (T+10)

```bash
#!/bin/bash
# Production smoke test script

echo "Running production smoke tests..."

# Test 1: API Availability
echo "Test 1: API Availability"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/)
if [ $RESPONSE = "200" ]; then
  echo "✓ PASS"
else
  echo "✗ FAIL - Got $RESPONSE"
  exit 1
fi

# Test 2: Model Prediction
echo "Test 2: Model Prediction"
RESPONSE=$(curl -s -X POST http://localhost:5000/api/predict \
  -H "Content-Type: application/json" \
  -d '{"square_feet": 2500, "bedrooms": 4}')
if echo $RESPONSE | grep -q "prediction"; then
  echo "✓ PASS"
else
  echo "✗ FAIL - Invalid response"
  exit 1
fi

# Test 3: Database Query
echo "Test 3: Database Connectivity"
docker exec houseprice-prod curl -s http://postgres:5432/ > /dev/null
if [ $? = "0" ]; then
  echo "✓ PASS"
else
  echo "✗ FAIL - Database not accessible"
  exit 1
fi

# Test 4: Cache Availability
echo "Test 4: Cache System"
docker exec houseprice-prod redis-cli -h redis ping > /dev/null
if [ $? = "0" ]; then
  echo "✓ PASS"
else
  echo "✗ FAIL - Cache not available"
  exit 1
fi

echo ""
echo "All smoke tests PASSED ✓"
```

### Step 7: Notify Stakeholders

```bash
# Slack notification
curl -X POST $SLACK_WEBHOOK -H 'Content-type: application/json' \
  --data '{
    "text": "🚀 PRODUCTION DEPLOYMENT SUCCESSFUL",
    "blocks": [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "*Build #1234* deployed to production successfully\n\n*Changes:*\n• Updated ML model\n• Performance improvements\n• Security patches\n\n*Status:* All health checks passed ✅"
        }
      },
      {
        "type": "section",
        "fields": [
          {"type": "mrkdwn", "text": "*Deployment Time:*\nT+25 minutes"},
          {"type": "mrkdwn", "text": "*Rollback Available:*\nYes - Build #1233"}
        ]
      }
    ]
  }'

# Email notification
mail -s "PRODUCTION DEPLOYMENT COMPLETE #1234" \
  stakeholders@yourdomain.com << EOF
Production Deployment Notification

Build #1234 has been successfully deployed to production.

Deployment Details:
- Start Time: [Time]
- Completion Time: [Time]
- Duration: 25 minutes
- Status: SUCCESS ✅

What Changed:
- Updated ML model version
- Performance optimizations
- Security vulnerability fixes

Rollback Information:
- Rollback available to Build #1233
- Time to rollback: < 5 minutes
- Rollback contact: devops-team@yourdomain.com

Next Steps:
- Monitor application performance
- Check error logs for 24 hours
- Gather user feedback

Questions? Contact: devops-team@yourdomain.com
EOF
```

---

## Rollback Procedures

### When to Rollback

Immediately rollback if any of these occur:

```
✗ Application crashes/won't start
✗ API response time > 500ms
✗ Error rate > 1%
✗ Database connectivity lost
✗ Critical business feature broken
✗ Security issue detected
✗ Data corruption detected
```

### Quick Rollback (< 5 Minutes)

**For DEV/QA/UAT** (if needed):

```bash
# Step 1: Stop current container
docker stop houseprice-$(ENVIRONMENT)

# Step 2: Start previous version
docker run -d --name houseprice-$(ENVIRONMENT) \
  -p $(PORT):5000 \
  housepriceprediction:PREVIOUS-BUILD

# Step 3: Verify
curl http://localhost:$(PORT)/
docker logs houseprice-$(ENVIRONMENT)
```

**For PRODUCTION**:

```bash
#!/bin/bash
# PRODUCTION Rollback Script

echo "🚨 INITIATING PRODUCTION ROLLBACK"
echo "Timestamp: $(date)"

# Step 1: Create incident ticket
echo "Creating incident ticket..."
# Send to incident management system

# Step 2: Gracefully stop current deployment
echo "Stopping current deployment..."
docker stop houseprice-prod
sleep 5

# Step 3: Restore previous version
echo "Restoring previous version..."
PREVIOUS_BUILD=$(docker images housepriceprediction | sed -n '2p' | awk '{print $2}')
docker run -d --name houseprice-prod -p 5000:5000 \
  --restart=always \
  housepriceprediction:$PREVIOUS_BUILD

# Step 4: Verify
echo "Verifying rollback..."
sleep 10

for i in {1..30}; do
  if curl -s http://localhost:5000/ > /dev/null; then
    echo "✓ Application is responding"
    break
  fi
  echo "Waiting... attempt $i/30"
  sleep 2
done

# Step 5: Verify database integrity
echo "Checking database integrity..."
docker exec houseprice-prod curl -s http://postgres:5432/ > /dev/null
if [ $? = "0" ]; then
  echo "✓ Database connection OK"
else
  echo "✗ Database issue - investigate immediately"
fi

# Step 6: Notify
echo "📢 ROLLBACK COMPLETE"
echo "Rollback to Build: $PREVIOUS_BUILD"
echo "Timestamp: $(date)"
echo "Status: SUCCESS"

# Notify slack
curl -X POST $SLACK_WEBHOOK -d 'text=🚨 PRODUCTION ROLLBACK COMPLETE - Build '$PREVIOUS_BUILD

# Send email
mail -s "URGENT: Production Rollback Executed" \
  devops-team@yourdomain.com << EOF
Production Rollback Notification

A production rollback has been executed.

Current Status:
- Rolled back to Build: $PREVIOUS_BUILD
- Application Status: ONLINE
- Database Status: OPERATIONAL

Next Steps:
1. Investigate root cause
2. Review logs from failed deployment
3. Schedule incident review meeting
4. Fix identified issues
5. Re-test before re-deploying

This is an automated notification.
Questions? Contact: devops-lead@yourdomain.com
EOF

exit 0
```

### Post-Rollback Actions

```bash
# 1. Restore database if needed
psql -U prod_user -d houseprice_db \
  < /backups/prod/houseprice_db_BACKUP_TIMESTAMP.sql

# 2. Clear cache
docker exec houseprice-redis redis-cli FLUSHALL

# 3. Verify application again
for i in {1..5}; do
  curl -s http://localhost:5000/ > /dev/null
  echo "Test $i: OK"
done

# 4. Document incident
cat > rollback-incident-report.txt << EOF
Rollback Incident Report
========================
Date: $(date)
Build Rolled Back From: #1234
Build Rolled Back To: #1233
Reason: [Critical error description]
Impact: [User impact assessment]
Root Cause: [Investigation result]
Actions Taken: [Steps performed]
Time to Resolve: [Duration]
Follow-up Required: [Yes/No]
EOF

# 5. Schedule incident review
# Create meeting to discuss:
# - What went wrong
# - How to prevent in future
# - Improvements to testing
# - Process improvements
```

---

## Incident Response

### On-Call Procedures

**During Business Hours**:
- Immediately alert: devops-lead@yourdomain.com
- Slack: @devops-on-call
- Phone: [Number]

**After Hours**:
- Page on-call engineer via PagerDuty
- Emergency hotline: [Number]
- SMS alert: [Setup details]

### Incident Response Timeline

```
0:00 - Issue detected
  ├─ Alert triggered
  ├─ On-call engineer paged
  └─ Incident ticket created

5:00 - Incident assessment
  ├─ Severity determined
  ├─ Impact evaluated
  └─ Response plan created

10:00 - Mitigation started
  ├─ Rollback OR
  ├─ Patch deployed OR
  └─ Workaround implemented

20:00 - System stabilized
  ├─ All checks passed
  ├─ User impact resolved
  └─ Monitoring intensified

60:00+ - Post-incident
  ├─ Root cause analysis
  ├─ Preventive measures
  └─ Knowledge documentation
```

### Escalation Path

```
Application Issue Detected
  ↓
Level 1: DevOps Team
  └─ Try to resolve < 15 min
  └─ If escalate → Level 2
  ↓
Level 2: Engineering Manager + Senior DevOps
  └─ Try to resolve < 30 min
  └─ If critical → Level 3
  ↓
Level 3: VP Engineering + Infrastructure Lead
  └─ Executive decision making
  └─ All hands on deck
```

---

## Post-Deployment Verification

### 24-Hour Monitoring Checklist

**Hour 1**: Critical Checks
- [ ] Application responding to all requests
- [ ] API response time < 100ms (p95)
- [ ] Error rate < 0.1%
- [ ] Database connectivity stable
- [ ] Cache working correctly
- [ ] No critical errors in logs
- [ ] User reports: No issues

**Hour 24**: Stability Verification
- [ ] Uptime = 100%
- [ ] Average response time stable
- [ ] No memory leaks (memory usage stable)
- [ ] CPU usage normal (< 50%)
- [ ] Disk space available (> 30% free)
- [ ] Backup completed successfully
- [ ] No unresolved alerts

### Metrics to Monitor

```bash
#!/bin/bash
# Deployment monitoring script

echo "Post-Deployment Metrics"
echo "======================"
echo "Timestamp: $(date)"
echo ""

# 1. Availability
UPTIME=$(docker stats houseprice-prod --no-stream --format "{{.Container}}: {{.MemUsage}}")
echo "Container Status: $UPTIME"

# 2. Performance
echo "Response Time: $(curl -w "%{time_total}s" -s -o /dev/null http://localhost:5000/)"

# 3. Error Rate
ERRORS=$(docker logs houseprice-prod --since 1h | grep -i error | wc -l)
echo "Errors in Last Hour: $ERRORS"

# 4. Resource Usage
docker stats houseprice-prod --no-stream \
  --format "CPU: {{.CPUPerc}} | Memory: {{.MemUsage}}"

# 5. Active Connections
CONNECTIONS=$(docker exec houseprice-prod \
  ps aux | grep -i flask | wc -l)
echo "Active Processes: $CONNECTIONS"

# 6. Disk Space
DISK=$(df -h / | tail -1 | awk '{print $5}')
echo "Disk Usage: $DISK"

echo ""
echo "✓ Monitoring snapshot complete"
```

---

## Monitoring After Deployment

### Setup Monitoring Dashboard

After production deployment, create monitoring dashboard:

```
Dashboard: Deployment Monitoring
├─ Application Health
│  ├─ API Availability (99.9% target)
│  ├─ Response Time p95 (< 200ms)
│  └─ Error Rate (< 0.1%)
│
├─ System Performance
│  ├─ CPU Usage
│  ├─ Memory Usage
│  ├─ Disk I/O
│  └─ Network I/O
│
├─ Database Performance
│  ├─ Connection Pool Usage
│  ├─ Query Performance
│  ├─ Transaction Rate
│  └─ Replication Lag
│
├─ Business Metrics
│  ├─ Predictions Per Hour
│  ├─ Avg Prediction Accuracy
│  ├─ User Error Rate
│  └─ Throughput
│
└─ Alerts Triggered
   ├─ Critical
   ├─ Warning
   └─ Info
```

### Alert Configuration

```yaml
Alerts:
  CriticalHighErrorRate:
    condition: error_rate > 1%
    window: 5 minutes
    action: Page on-call engineer, Slack alert
    
  ResponseTimeHigh:
    condition: p95_latency > 500ms
    window: 10 minutes
    action: Slack alert, Create ticket
    
  HighMemoryUsage:
    condition: memory_usage > 90%
    window: 5 minutes
    action: Auto-scale OR notify
    
  DatabaseDown:
    condition: db_connectivity = false
    window: 1 minute
    action: Page on-call + VP Eng, Emergency escalation
    
  DiskSpaceLow:
    condition: disk_available < 20%
    window: none (immediate)
    action: Alert + Maintenance window
```

### Sign-Off Procedure

```bash
# After monitoring for 24 hours, complete sign-off:

cat > deployment-sign-off.txt << EOF
Deployment Sign-Off Report
==========================
Build Number: #1234
Deployed By: [Name]
Deployment Date: [Date]
Sign-Off Date: [Date]

Monitoring Results (24 hours):
- Availability: 99.99% ✓
- Error Rate: 0.03% ✓
- Avg Response Time: 45ms ✓
- Peak Response Time: 120ms ✓
- User Feedback: Positive ✓
- Performance Baselines: Met ✓

Issues Found: None

Rollback Status: Available - Build #1233

Signed Off By: [Name]
Date: [Date]
EOF

# Archive report
cp deployment-sign-off.txt /deployments/history/$(date +%Y%m%d)_sign-off.txt

# Notify stakeholders
mail -s "Deployment #1234 - 24hr Sign-Off Complete" \
  stakeholders@yourdomain.com < deployment-sign-off.txt
```

---

## Emergency Procedures

### Complete Application Failure

```bash
#!/bin/bash
# EMERGENCY: Complete application recovery

echo "🚨 EMERGENCY RECOVERY INITIATED"

# Step 1: Create incident (immediate)
# Contact: ALL
# Slack: @channel
# PagerDuty: Page everyone

# Step 2: Stop bleeding (immediate)
# Option A: Rollback
docker stop houseprice-prod
docker run -d --name houseprice-prod \
  housepriceprediction:LAST_KNOWN_GOOD

# Option B: Failover
# Switch DNS to backup server
# nsupdate -k /etc/bind/keys/update.key << EOF
# server dns.yourdomain.com
# zone yourdomain.com
# update delete api.yourdomain.com
# update add api.yourdomain.com 300 A BACKUP_IP
# send
# EOF

# Step 3: Verify recovery (5 min)
sleep 10
curl -s http://localhost:5000/ > /dev/null

# Step 4: Notify
# Slack: 🟢 Service restored
# Email: service alert
# Status page: Update status

# Step 5: Investigate
# Collect logs
# Database integrity check
# Security review if applicable

# Step 6: Post-incident
# Full incident review within 24 hours
# Preventive measures for future
```

### Database Corruption/Loss

```bash
# IF BACKUP AVAILABLE:
1. Stop application
2. Restore database from backup
   psql -U prod_user -d houseprice_db < /backups/houseprice_db_LATEST.sql
3. Verify data integrity
4. Restart application

# IF NO BACKUP:
1. CRITICAL - Contact CTO/VP immediately
2. Assess data loss impact
3. Determine recovery options:
   - Point-in-time recovery (if available)
   - Rebuild from secondary/replica
   - Accept data loss and notify users
4. Document lesson learned
```

### Security Breach Response

```bash
# IMMEDIATE (First 5 minutes):
1. Stop affected application
2. Alert security team + CEO + legal
3. Isolate affected systems
4. Don't destroy logs

# FIRST HOUR:
1. Investigate scope of breach
2. Check for data exfiltration
3. Review security logs
4. Determine if customer data affected

# NOTIFICATION (As required by law):
1. Inform affected customers
2. Provide credit monitoring if applicable
3. Law enforcement notification if required
4. Regulatory reporting

# RECOVERY:
1. Patch vulnerability
2. Security audit
3. Restore from clean backup
4. Monitor for signs of reinfection
```

---

## Checklists & Templates

### Pre-Deployment Checklist

```markdown
## Deployment Pre-Check for Build #____

- [ ] Code merged to main branch
- [ ] All tests passing (coverage > 80%)
- [ ] Security scan complete (no critical issues)
- [ ] Performance tests passed
- [ ] SonarQube analysis passed
- [ ] Database migrations tested
- [ ] Environment variables updated
- [ ] Documentation updated
- [ ] Changelog updated
- [ ] Product owner approval
- [ ] Tech lead approval
- [ ] Stakeholders notified
```

### Post-Deployment Checklist

```markdown
## Post-Deployment Verification for Build #____

Immediate (0-5 min):
- [ ] Application container running
- [ ] Health checks passing
- [ ] No error logs
- [ ] Basic API test passing
- [ ] Database connectivity verified

Short-term (5-30 min):
- [ ] Performance baseline met
- [ ] No spike in error rate
- [ ] Resource usage normal
- [ ] User reports: OK
- [ ] Monitoring alerts: Green

24-Hour:
- [ ] Uptime = 100%
- [ ] No memory leaks
- [ ] No cascading failures
- [ ] Backup completed
- [ ] Sign-off completed
```

---

## Quick Reference Commands

### Docker Commands

```bash
# View running containers
docker ps

# View all containers
docker ps -a

# Container logs
docker logs houseprice-prod --tail 100 --follow

# Container stats
docker stats houseprice-prod

# Access container shell
docker exec -it houseprice-prod /bin/bash

# Stop container gracefully
docker stop houseprice-prod

# Force stop
docker kill houseprice-prod

# Remove container
docker rm houseprice-prod

# Container details
docker inspect houseprice-prod

# Export container as image
docker commit houseprice-prod housepriceprediction:backup
```

### Curl Testing Commands

```bash
# Basic health check
curl http://localhost:5000/

# Detailed response info
curl -v http://localhost:5000/

# Response time
curl -w "Time: %{time_total}s\n" http://localhost:5000/

# Status code only
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:5000/

# POST request
curl -X POST http://localhost:5000/api/predict \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'

# With authentication
curl -H "Authorization: Bearer TOKEN" http://localhost:5000/

# Continuous monitoring
watch -n 5 'curl -w "%{http_code} - %{time_total}s\n" -s -o /dev/null http://localhost:5000/'
```

### Database Commands

```bash
# Connect to database
psql -h postgres -U housepriceuser -d houseprice_db

# Check database size
SELECT pg_size_pretty(pg_database_size('houseprice_db'));

# List tables
\dt

# View running queries
SELECT * FROM pg_stat_activity;

# Backup database
pg_dump houseprice_db > backup.sql

# Restore database
psql -d houseprice_db < backup.sql

# Kill long-running query
SELECT pg_terminate_backend(pid);
```

---

## Contact & Escalation

```
On-Call Schedule: [Link to calendar]

DevOps Team
├─ Lead: [Name] - [Phone] - [Email]
├─ Engineer: [Name] - [Phone] - [Email]
└─ Engineer: [Name] - [Phone] - [Email]

Engineering Manager: [Name] - [Phone] - [Email]
VP Engineering: [Name] - [Phone] - [Email]
CTO: [Name] - [Phone] - [Email]

Incident Channel: #devops-incidents (Slack)
War Room: [Zoom link]
Status Page: https://status.yourdomain.com
```

---

**Last Updated**: 2024
**Version**: 1.0
**Next Review**: [Date]

---

**Remember**: When in doubt, consult this runbook and your team. Safety first, speed second.
