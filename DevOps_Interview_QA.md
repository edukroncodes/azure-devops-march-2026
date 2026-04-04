# DevOps Interview Questions & Answers
## Azure DevOps | Kubernetes | Terraform | Azure DevOps YAML Pipelines

> **100 Real-Time Interview Questions with Detailed Answers**
> Covers beginner to advanced level concepts with real-world examples.

---

# PART 1: AZURE DEVOPS (Questions 1–25)

---

## Q1. What is Azure DevOps and what are its core services?

**Answer:**

Azure DevOps is a cloud-based DevOps platform by Microsoft that provides a complete set of tools for software development, project management, and deployment. It enables teams to plan smarter, collaborate better, and ship faster using modern DevOps practices.

**Core Services:**

| Service | Purpose |
|---------|---------|
| **Azure Boards** | Agile project management — Kanban boards, backlogs, sprints, work items, epics, and user stories |
| **Azure Repos** | Git-based or TFVC source code repositories with pull requests, branch policies, and code reviews |
| **Azure Pipelines** | CI/CD automation — build, test, and deploy to any cloud or on-premises |
| **Azure Test Plans** | Manual, exploratory, and automated testing management |
| **Azure Artifacts** | Package management for NuGet, npm, Maven, PyPI, and universal packages |

**Real-world context:** A team building a microservices application uses Azure Boards to plan sprints, Azure Repos to host code, Azure Pipelines to build Docker images and push to AKS, and Azure Artifacts to host internal npm packages.

---

## Q2. What is the difference between a Build Pipeline and a Release Pipeline in Azure DevOps?

**Answer:**

| Aspect | Build Pipeline (CI) | Release Pipeline (CD) |
|--------|--------------------|-----------------------|
| **Purpose** | Compile, test, and package the application | Deploy the packaged artifact to environments |
| **Trigger** | Code commit, pull request, schedule | Successful build, manual approval |
| **Output** | Build artifact (zip, Docker image, etc.) | Deployed application in target environment |
| **Configuration** | YAML or Classic editor | Classic editor (or YAML multi-stage) |
| **Environments** | N/A | Dev → QA → Staging → Production |

**Example flow:**
```
Developer pushes code
        ↓
Build Pipeline triggers
  → Restore dependencies
  → Run unit tests
  → Build Docker image
  → Push to ACR
        ↓
Release Pipeline triggers
  → Deploy to Dev AKS namespace
  → Run smoke tests
  → Manual approval gate
  → Deploy to Production AKS
```

---

## Q3. What is a Service Connection in Azure DevOps and why is it important?

**Answer:**

A **Service Connection** is a saved, secure connection from Azure DevOps to an external service (e.g., Azure subscription, Docker Hub, GitHub, Kubernetes cluster, SonarQube). It stores credentials securely so pipelines can authenticate to external systems without hardcoding secrets.

**Common types:**

| Type | Use Case |
|------|----------|
| **Azure Resource Manager (ARM)** | Deploy to Azure resources — VMs, App Services, AKS |
| **Docker Registry** | Push/pull images from Docker Hub or ACR |
| **Kubernetes** | Deploy manifests to a Kubernetes cluster |
| **GitHub** | Trigger pipelines from GitHub repos |
| **Generic / SSH** | Connect to any external system |

**How it works:**
1. Navigate to **Project Settings → Service Connections**
2. Click **New service connection** and choose type
3. Authenticate (OAuth, service principal, or PAT)
4. Grant access to specific pipelines or all pipelines

**Security best practice:** Use service principals with the minimum required RBAC role (e.g., `Contributor` on a specific resource group, not the whole subscription). Rotate secrets regularly.

---

## Q4. What are Branch Policies in Azure Repos and how do you configure them?

**Answer:**

Branch policies are rules enforced on branches (typically `main` or `master`) to protect code quality before merging. They prevent direct pushes and require work to go through pull requests.

**Key branch policies:**

| Policy | Description |
|--------|-------------|
| **Require minimum reviewers** | At least N approvals required before merge |
| **Check for linked work items** | PR must reference an Azure Boards work item |
| **Check for comment resolution** | All review comments must be resolved |
| **Require a successful build** | CI pipeline must pass before merge |
| **Limit merge types** | Allow only squash, rebase, or merge commits |
| **Automatically include code reviewers** | Auto-assign reviewers based on file paths |

**Configuration steps:**
1. Go to **Azure Repos → Branches**
2. Click the `...` menu on the branch → **Branch policies**
3. Toggle and configure each policy

**Real-world scenario:** For a production branch, require 2 approvers, a passing build, all comments resolved, and only squash merges. This ensures code quality and a clean git history.

---

## Q5. How does Azure DevOps handle secrets and sensitive data in pipelines?

**Answer:**

Azure DevOps provides multiple mechanisms to handle secrets securely:

**1. Pipeline Secret Variables**
- Mark a variable as secret in the pipeline UI — its value is masked in all logs
- Cannot be passed between stages unless explicitly mapped

**2. Variable Groups**
- Centrally managed groups of variables (name/value pairs)
- Linked to pipelines via the Library
- Can link directly to **Azure Key Vault** to sync secrets automatically

**3. Azure Key Vault Integration**
```yaml
variables:
  - group: my-keyvault-variable-group

steps:
  - script: echo "$(my-secret)"  # Value is masked in logs
```

**4. Secure Files**
- Upload certificates, provisioning profiles, SSH keys
- Referenced in pipelines using the `DownloadSecureFile` task

**Best practices:**
- Never hardcode secrets in YAML files
- Use Key Vault as the single source of truth
- Restrict variable group access to specific pipelines
- Rotate secrets regularly and use short-lived credentials
- Audit pipeline logs — masked values should never appear in plain text

---

## Q6. What is the difference between Self-Hosted and Microsoft-Hosted agents?

**Answer:**

| Aspect | Microsoft-Hosted Agents | Self-Hosted Agents |
|--------|------------------------|-------------------|
| **Management** | Managed by Microsoft | Managed by your team |
| **Cost** | Included free tier + paid minutes | No agent cost; your infrastructure cost |
| **Pre-installed tools** | Pre-configured (Node, Python, .NET, Docker, etc.) | You install what you need |
| **Persistence** | Fresh VM every job run | Persists between runs (caches, tools) |
| **Network access** | Public internet only | Can access private/internal resources |
| **Performance** | Standard hardware | Customize RAM, CPU, disk |
| **Pool** | `ubuntu-latest`, `windows-latest`, `macos-latest` | Custom pool name |

**When to use self-hosted:**
- Need access to private networks (databases, internal APIs)
- Require specific software/hardware (GPUs for ML, proprietary tools)
- Want to leverage build caching for faster builds
- Need compliance with data residency requirements

**Self-hosted agent setup (Linux):**
```bash
mkdir myagent && cd myagent
curl -O https://vstsagentpackage.blob.core.windows.net/agent/latest/vsts-agent-linux-x64-latest.tar.gz
tar zxvf vsts-agent-linux-x64-latest.tar.gz
./config.sh --url https://dev.azure.com/myorg --auth pat --token <PAT>
./run.sh  # or install as service with ./svc.sh install
```

---

## Q7. What are Environments in Azure DevOps Pipelines?

**Answer:**

An **Environment** in Azure DevOps represents a collection of resources (Kubernetes namespaces, virtual machines, or generic targets) where your application is deployed. Environments provide deployment history, approval gates, and resource-level tracking.

**Key features:**

| Feature | Description |
|---------|-------------|
| **Deployment history** | Track which build version was deployed when and by whom |
| **Approvals & checks** | Require manual approval before deployment proceeds |
| **Resource types** | Kubernetes namespace, VM, or generic |
| **Branch control** | Only allow deployments from specific branches |
| **Exclusive lock** | Prevent parallel deployments to the same environment |

**Example — Kubernetes environment:**
```yaml
jobs:
  - deployment: DeployToProduction
    environment:
      name: production
      resourceType: Kubernetes
      resourceName: my-aks-cluster
    strategy:
      runOnce:
        deploy:
          steps:
            - task: KubernetesManifest@0
              inputs:
                action: deploy
                manifests: manifests/*.yaml
```

**Real-world use:** Configure the `production` environment to require approval from 2 senior engineers, allow deployments only from the `main` branch, and add a 30-minute delay after QA deployment before production can proceed.

---

## Q8. What is the purpose of Azure Artifacts and how does it work with pipelines?

**Answer:**

**Azure Artifacts** is a universal package management service that hosts packages for NuGet, npm, Maven, Python (PyPI), Cargo, and Universal Packages. It serves as a private package registry for your organization.

**Key use cases:**
- Host internal libraries shared across teams
- Cache public packages (upstream sources) to improve build reliability
- Store build artifacts for later deployment stages
- Control which package versions are used in production

**Pipeline integration example (npm):**
```yaml
steps:
  - task: NodeTool@0
    inputs:
      versionSpec: '18.x'

  - task: Npm@1
    displayName: 'Authenticate to Artifacts feed'
    inputs:
      command: custom
      customCommand: install
      customRegistry: useFeed
      customFeed: 'my-project/my-feed'

  - script: npm install
  - script: npm run build
```

**Upstream sources:** Azure Artifacts can proxy public registries (npmjs.com, pypi.org) and cache packages. If a public package is unavailable, builds still succeed using the cached version.

**Retention policies:** Set policies to automatically clean up old package versions, keeping storage costs low.

---

## Q9. Explain Azure DevOps organization structure — Organization, Project, Teams, and Repos.

**Answer:**

Azure DevOps follows a hierarchical structure:

```
Organization (contoso.visualstudio.com)
├── Project A (E-Commerce Platform)
│   ├── Teams: Frontend Team, Backend Team, QA Team
│   ├── Repos: frontend-repo, backend-repo, infra-repo
│   ├── Boards: Backlog, Sprints, Kanban boards
│   ├── Pipelines: CI/CD for each service
│   └── Artifacts: npm feed, NuGet feed
│
└── Project B (Mobile App)
    ├── Teams: iOS Team, Android Team
    └── ...
```

**Organization:** Top-level container. One per company/division. Manages billing, users, and global policies.

**Project:** Container for all work related to a product or initiative. Has its own boards, repos, pipelines, and access controls.

**Teams:** Sub-groups within a project with their own board views, backlogs, sprints, and notification settings.

**Repos:** One project can have multiple Git repositories (e.g., one per microservice).

**Access levels:**

| Level | Capabilities |
|-------|-------------|
| **Stakeholder** | View boards, create work items (free) |
| **Basic** | Full access to Boards, Repos, Pipelines |
| **Basic + Test Plans** | Includes Azure Test Plans |
| **Visual Studio subscriber** | All features via subscription |

---

## Q10. What are Deployment Groups in Azure DevOps?

**Answer:**

**Deployment Groups** are a logical set of target machines (physical or virtual) where your release pipeline deploys application artifacts. Unlike environments (which target Kubernetes), deployment groups target traditional VMs or bare-metal servers.

**How it works:**
1. Register target machines by installing the Azure DevOps agent on each VM
2. Create a Deployment Group in Azure DevOps and copy the registration script
3. Run the script on each target machine — it registers and appears in the group
4. Reference the Deployment Group in a Release Pipeline stage

**Registration script (on target VM):**
```bash
# Run on each target machine
wget https://vstsagentpackage.blob.core.windows.net/agent/latest/vsts-agent-linux-x64-latest.tar.gz
./config.sh --deploymentgroup --url https://dev.azure.com/myorg \
            --auth pat --token <PAT> \
            --projectname MyProject \
            --deploymentgroupname MyServers
```

**Use case:** Deploying a .NET application to 10 IIS web servers. The release pipeline uses a Deployment Group task to run IIS configuration scripts and copy build artifacts to all servers in parallel or rolling fashion.

**Tags:** Tag machines (e.g., `web`, `db`, `staging`) and target specific subsets in pipeline stages.

---

## Q11. How do you implement approval gates in Azure DevOps?

**Answer:**

Approval gates enforce human review or automated checks before a deployment proceeds. They exist at two levels:

**1. Pre/Post-deployment approvals (Classic Release Pipelines)**
- Configure approvers per stage
- Approvers receive email notifications
- Can set timeout and rejection behavior

**2. Environment Approvals & Checks (YAML Pipelines)**
Configure in **Environments** under **Approvals and checks**:

| Check type | Description |
|-----------|-------------|
| **Approvals** | Named users/groups must approve |
| **Branch control** | Only allow specific branches |
| **Business hours** | Deployments only during working hours |
| **Invoke REST API** | Call an external API; proceed if it returns success |
| **Query Azure Monitor alerts** | Block if active alerts exist |
| **Required template** | Pipeline must use approved YAML templates |
| **Exclusive lock** | Only one deployment at a time |

**Example — Business hours check:**
```
Check: Business Hours
Time zone: UTC+5:30
Working days: Monday–Friday
Working hours: 09:00–18:00
Action if outside hours: Reject
```

**Real-world scenario:** For a banking app, configure the production environment to require approval from the Release Manager AND the Security Lead, with a 24-hour timeout. If not approved, the deployment is automatically rejected and the team is notified via Teams.

---

## Q12. What is the difference between Agile, Scrum, and CMMI process templates in Azure Boards?

**Answer:**

When creating a project in Azure DevOps, you choose a process template that defines the work item types and workflows available:

| Feature | Agile | Scrum | CMMI |
|---------|-------|-------|------|
| **Top-level item** | Epic | Epic | Epic |
| **Mid-level** | Feature | Feature | Feature |
| **Work item** | User Story | Product Backlog Item | Requirement |
| **Bug tracking** | Bug (separate) | Bug (in backlog) | Bug |
| **Task** | Task | Task | Task |
| **Suited for** | General Agile teams | Scrum teams with sprints | Process-maturity regulated industries |
| **Complexity** | Simple | Simple-Medium | Complex (audit trails) |

**Agile** is the most commonly used template — flexible, easy to adopt, supports user stories, epics, and bugs.

**Scrum** closely mirrors the Scrum framework — product backlog items, sprint planning, and velocity tracking.

**CMMI (Capability Maturity Model Integration)** is for organizations that need formal change management, requirements traceability, and detailed audit trails (e.g., defense, government, healthcare).

**Recommendation:** Use **Agile** for most software teams. Use **CMMI** only if you're under regulatory requirements.

---

## Q13. How do you configure notifications and alerts in Azure DevOps?

**Answer:**

Azure DevOps supports notifications at multiple levels:

**1. Personal notifications** — Each user can configure their own alerts for events like PR reviews assigned, build failures for their commits, etc.

**2. Team notifications** — Configured by team admins for the entire team.

**3. Project notifications** — Configured by project administrators for project-wide events.

**4. Service Hooks** — Send notifications to external services.

**Common notification triggers:**

| Category | Events |
|----------|--------|
| Build | Build completion, build quality change, stage approval |
| Code | Pull request updated, reviewer added, PR merged |
| Work | Work item assigned, work item state changed |
| Release | Release created, deployment started/completed/failed |

**Service Hooks integrations:**

```
Azure DevOps → Microsoft Teams (via Incoming Webhook or Teams connector)
Azure DevOps → Slack
Azure DevOps → PagerDuty
Azure DevOps → ServiceNow
Azure DevOps → Jenkins
Azure DevOps → Custom webhook endpoint
```

**Teams integration example:**
1. In Teams channel: Apps → Incoming Webhook → copy URL
2. In Azure DevOps: Project Settings → Service Hooks → New Subscription → Teams
3. Choose trigger events, paste webhook URL, test and save

---

## Q14. What is a Work Item in Azure Boards and what are the different types?

**Answer:**

A **Work Item** is the fundamental unit of tracking in Azure Boards. Every task, bug, requirement, or piece of work is represented as a work item with fields like title, assignee, state, priority, and custom fields.

**Work item hierarchy (Agile process):**

```
Epic
└── Feature
    └── User Story
        ├── Task
        └── Bug
```

**Standard work item types:**

| Type | Description | Example |
|------|-------------|---------|
| **Epic** | Large business initiative spanning multiple sprints | "Implement user authentication system" |
| **Feature** | A deliverable capability within an epic | "OAuth 2.0 login with Google" |
| **User Story** | End-user requirement in user-centric language | "As a user, I can log in with my Google account" |
| **Task** | Technical sub-task of a story | "Set up Google OAuth credentials in Key Vault" |
| **Bug** | Defect that needs fixing | "Login fails when email has uppercase letters" |
| **Test Case** | Automated or manual test scenario | "Verify login with valid Google token" |
| **Impediment** | Blocking issue (Scrum template) | "Waiting for security team approval" |

**States flow (Agile):**
```
New → Active → Resolved → Closed
         ↑         |
         └─────────┘ (can reopen)
```

---

## Q15. How do you use Azure DevOps REST API?

**Answer:**

The Azure DevOps REST API allows programmatic access to all Azure DevOps features — creating work items, triggering builds, querying pipelines, managing repositories, etc.

**Authentication:**
```bash
# Using Personal Access Token (PAT)
# Base64 encode ":PAT_TOKEN"
TOKEN=$(echo -n ":mypattoken" | base64)
curl -H "Authorization: Basic $TOKEN" \
     "https://dev.azure.com/{org}/{project}/_apis/build/builds?api-version=7.1"
```

**Common API endpoints:**

| Purpose | Endpoint |
|---------|---------|
| List builds | `GET /_apis/build/builds` |
| Queue a build | `POST /_apis/build/builds` |
| Get work items | `GET /_apis/wit/workitems/{id}` |
| Create work item | `POST /_apis/wit/workitems/$User Story` |
| List repositories | `GET /_apis/git/repositories` |
| Get pipeline runs | `GET /_apis/pipelines/{id}/runs` |

**Create a work item (Python example):**
```python
import requests
import base64

org = "myorg"
project = "MyProject"
pat = "my-pat-token"
token = base64.b64encode(f":{pat}".encode()).decode()

url = f"https://dev.azure.com/{org}/{project}/_apis/wit/workitems/$User%20Story?api-version=7.1"
headers = {
    "Authorization": f"Basic {token}",
    "Content-Type": "application/json-patch+json"
}
body = [
    {"op": "add", "path": "/fields/System.Title", "value": "New user story via API"},
    {"op": "add", "path": "/fields/System.Description", "value": "Created programmatically"}
]
response = requests.post(url, json=body, headers=headers)
print(response.json()['id'])
```

---

## Q16. What is Git Flow and how do you implement it with Azure Repos?

**Answer:**

**Git Flow** is a branching strategy that defines a structured workflow for feature development, releases, and hotfixes using specific branch types.

**Branch types:**

| Branch | Purpose | Merges into |
|--------|---------|-------------|
| `main` | Production-ready code | — |
| `develop` | Integration branch | `main` (via release) |
| `feature/xxx` | New features | `develop` |
| `release/x.x.x` | Release stabilization | `main` + `develop` |
| `hotfix/xxx` | Critical production fixes | `main` + `develop` |

**Workflow:**
```
main ─────────────────────────────────────────────── (production releases)
       ↑                     ↑                  ↑
develop ────────────────────────────────────────────
       ↑            ↑
feature/login   feature/payments
```

**Implementing with Azure Repos:**
1. Create branch policies on `main` and `develop` (require PRs, build validation)
2. Create branch naming conventions: `feature/*`, `release/*`, `hotfix/*`
3. Use pull request templates to standardize PR descriptions
4. Enable automatic deletion of feature branches after merge

**Azure DevOps branch protection:**
```
main branch policy:
  ✓ Require 2 reviewers
  ✓ Block direct pushes
  ✓ Require successful build
  ✓ Squash merge only
```

---

## Q17. What are Azure DevOps Extensions and Marketplace?

**Answer:**

The **Azure DevOps Marketplace** is a gallery of extensions built by Microsoft and the community that add extra functionality to Azure DevOps. Extensions can add new pipeline tasks, dashboard widgets, board integrations, test tools, and more.

**Popular extensions:**

| Extension | Purpose |
|-----------|---------|
| **SonarQube / SonarCloud** | Code quality and security scanning |
| **Terraform** | Run Terraform commands in pipelines |
| **Kubernetes (kubectl)** | Deploy to Kubernetes clusters |
| **WhiteSource Bolt** | Open-source vulnerability scanning |
| **Slack Notification** | Send pipeline notifications to Slack |
| **GitVersion** | Semantic versioning for builds |
| **Test Results Trend** | Visualize test result trends on dashboards |
| **OWASP ZAP** | Dynamic security testing (DAST) |

**Installing an extension:**
1. Go to **Azure DevOps Marketplace** (marketplace.visualstudio.com/azuredevops)
2. Find the extension and click **Get it free**
3. Select your organization and install
4. The task becomes available in all pipelines in that organization

**Creating a custom extension:** Use the Azure DevOps Extension SDK, define a `vss-extension.json` manifest, and publish to the marketplace (public or private).

---

## Q18. How do you set up a multi-stage deployment with gates in Azure DevOps?

**Answer:**

Multi-stage deployments model the full journey from code to production, with automated and manual gates between each stage.

**Release pipeline stages:**
```
Build → Dev Deploy → QA Deploy → Staging Deploy → Production Deploy
         (auto)      (auto)       (approval)        (approval + gate)
```

**Automated gates (Classic Release Pipelines):**

| Gate type | Description |
|-----------|-------------|
| **Azure Monitor** | Query for active alerts; fail if alerts exist |
| **Azure Function** | Call a custom function and check return value |
| **REST API** | Call any HTTP endpoint; evaluate JSON response |
| **Work item query** | Ensure no open P1 bugs before production |
| **Security and compliance** | Azure Policy compliance check |

**Example gate:** Before deploying to production, automatically query Azure Monitor for any active critical alerts on the staging environment. If alerts exist, retry every 5 minutes for up to 1 hour. If still failing after 1 hour, reject the deployment.

**YAML multi-stage with environment checks:**
```yaml
stages:
  - stage: DeployDev
    jobs:
      - deployment: Dev
        environment: dev
        # Deploys automatically

  - stage: DeployProd
    dependsOn: DeployDev
    jobs:
      - deployment: Prod
        environment: production  # Has manual approval configured
        strategy:
          runOnce:
            deploy:
              steps:
                - script: echo "Deploying to production"
```

---

## Q19. Explain Azure DevOps Test Plans and how to integrate automated tests.

**Answer:**

**Azure Test Plans** provides tools for manual testing, exploratory testing, and automated test management.

**Components:**

| Component | Description |
|-----------|-------------|
| **Test Plan** | Container for all testing activities in a sprint |
| **Test Suite** | Logical grouping of test cases (static, requirement-based, query-based) |
| **Test Case** | Individual test with steps, expected results, and attachments |
| **Test Run** | Execution of one or more test cases; records results |
| **Shared Steps** | Reusable step sequences (e.g., login steps) |

**Integrating automated tests:**

```yaml
# Run tests in pipeline and publish results
steps:
  - task: DotNetCoreCLI@2
    displayName: 'Run Unit Tests'
    inputs:
      command: 'test'
      projects: '**/*Tests/*.csproj'
      arguments: '--collect:"XPlat Code Coverage" --logger trx'
      publishTestResults: true

  - task: PublishTestResults@2
    inputs:
      testResultsFormat: 'VSTest'
      testResultsFiles: '**/*.trx'
      failTaskOnFailedTests: true

  - task: PublishCodeCoverageResults@1
    inputs:
      codeCoverageTool: 'Cobertura'
      summaryFileLocation: '**/coverage.cobertura.xml'
```

**Test result visibility:** Published test results appear in the pipeline summary, and can be linked to Test Plans work items for full traceability from requirement → test case → test result.

---

## Q20. What is the Azure DevOps Auditing feature?

**Answer:**

**Auditing** in Azure DevOps provides a log of security-relevant events across your organization for compliance and security investigation purposes.

**Captured events include:**

| Category | Events |
|----------|--------|
| **Access** | User sign-ins, token creation, permission changes |
| **Pipelines** | Pipeline created, modified, executed, service connection accessed |
| **Repos** | Repository created, deleted, branch policies changed |
| **Artifacts** | Feed created, package published, permissions changed |
| **Organization** | User added/removed, group membership changed |
| **Billing** | Subscription changes |

**Accessing audit logs:**
- Navigate to **Organization Settings → Auditing**
- Filter by date range, area, actor, or IP address
- Download as CSV for external SIEM tools

**Streaming audit logs:**
- Stream to Azure Monitor / Log Analytics for real-time alerting
- Stream to Splunk, Azure Event Hubs, or custom endpoints

**Compliance use case:** A financial organization must prove that only authorized personnel deployed to production. Audit logs show every pipeline run, who approved it, and when — exportable for SOC 2 or ISO 27001 audits.

**Retention:** Audit logs are retained for 90 days by default. Use streaming to preserve them longer in external storage.

---

## Q21. How do you use Azure DevOps with GitHub?

**Answer:**

Azure DevOps integrates deeply with GitHub in several ways:

**1. Azure Pipelines for GitHub repos:**
- Connect your GitHub account/org as a service connection
- Create a pipeline that triggers on GitHub push/PR events
- Build and deploy GitHub-hosted code using Azure Pipelines

```yaml
# azure-pipelines.yml in GitHub repo
trigger:
  branches:
    include:
      - main

pool:
  vmImage: 'ubuntu-latest'

steps:
  - script: echo "Building from GitHub"
```

**2. Azure Boards + GitHub:**
- Link GitHub commits and PRs to Azure Boards work items
- Use `AB#123` in commit messages to auto-link to work item 123
- View GitHub PR status directly on Azure Boards

**3. GitHub Actions + Azure:**
- Deploy from GitHub Actions to Azure resources using Azure-provided actions
- `Azure/login`, `Azure/webapps-deploy`, `Azure/k8s-deploy`

**4. Status badges:** GitHub README can show Azure Pipelines build status badges.

**Choosing between GitHub Actions and Azure Pipelines:**
- **GitHub Actions:** Best for open-source projects, simple workflows, GitHub-centric teams
- **Azure Pipelines:** Best for enterprise, complex deployments, Azure integration, compliance features

---

## Q22. What is Parallel Jobs in Azure DevOps and how is it licensed?

**Answer:**

**Parallel jobs** (also called parallel agents or concurrency) determine how many pipeline jobs can run simultaneously.

**Microsoft-hosted agents:**

| Plan | Parallel jobs | Free minutes/month |
|------|--------------|-------------------|
| **Free tier** | 1 | 1,800 (Linux/Mac), 1,800 (Windows) |
| **Additional job** | +1 | $40/month per extra parallel job |

**Self-hosted agents:**

| Plan | Parallel jobs |
|------|--------------|
| **Free tier** | 1 |
| **Additional job** | $15/month per extra parallel job |
| **Open-source projects** | Unlimited free |

**Impact of parallel jobs:**
- With 1 parallel job: if 5 pipelines trigger at once, 4 will queue
- With 5 parallel jobs: all 5 run simultaneously

**Optimizing parallel job usage:**
- Use **pipeline caching** to reduce build time
- **Combine stages** where possible
- Use **conditional execution** to skip unnecessary jobs
- **Fan-out/fan-in** patterns to parallelize within a pipeline
- Schedule non-urgent builds during off-peak hours

---

## Q23. How do you implement Infrastructure as Code (IaC) deployment using Azure DevOps?

**Answer:**

Azure DevOps integrates with IaC tools like Terraform, ARM templates, Bicep, and Ansible to automate infrastructure provisioning.

**Terraform pipeline example:**
```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

variables:
  - group: terraform-secrets  # Contains ARM_CLIENT_ID, ARM_CLIENT_SECRET, etc.
  - name: TF_VAR_environment
    value: 'production'

stages:
  - stage: TerraformPlan
    jobs:
      - job: Plan
        steps:
          - task: TerraformInstaller@0
            inputs:
              terraformVersion: '1.7.0'

          - task: TerraformTaskV4@4
            displayName: 'Terraform Init'
            inputs:
              provider: 'azurerm'
              command: 'init'
              backendServiceArm: 'my-azure-service-connection'
              backendAzureRmResourceGroupName: 'terraform-state-rg'
              backendAzureRmStorageAccountName: 'tfstatestorage'
              backendAzureRmContainerName: 'tfstate'
              backendAzureRmKey: 'prod.terraform.tfstate'

          - task: TerraformTaskV4@4
            displayName: 'Terraform Plan'
            inputs:
              provider: 'azurerm'
              command: 'plan'
              environmentServiceNameAzureRM: 'my-azure-service-connection'

  - stage: TerraformApply
    dependsOn: TerraformPlan
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: Apply
        environment: production  # Requires manual approval
        strategy:
          runOnce:
            deploy:
              steps:
                - task: TerraformTaskV4@4
                  displayName: 'Terraform Apply'
                  inputs:
                    provider: 'azurerm'
                    command: 'apply'
                    environmentServiceNameAzureRM: 'my-azure-service-connection'
```

---

## Q24. What are Pull Request Templates and how do you create one in Azure Repos?

**Answer:**

A **Pull Request template** is a pre-filled Markdown file that automatically populates the PR description when a developer opens a new PR. It ensures consistent information — changes made, testing done, checklist items — across all PRs.

**Creating a PR template in Azure Repos:**

1. Create a file at the repository root:
   - **Single template:** `.azuredevops/pull_request_template.md`
   - **Multiple templates:** `.azuredevops/pull_request_template/` folder with multiple `.md` files

**Example template:**
```markdown
## Description
Briefly describe the changes in this PR.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Work Items
Closes AB#___

## Testing Done
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manually tested in Dev environment

## Checklist
- [ ] Code follows team coding standards
- [ ] No hardcoded secrets or credentials
- [ ] Relevant documentation updated
- [ ] Database migrations included (if applicable)

## Screenshots (if applicable)
```

**Benefits:**
- Reduces back-and-forth asking for context
- Ensures testing steps are documented
- Links work items automatically
- Improves review quality and speed

---

## Q25. How do you implement a Blue-Green or Canary deployment strategy using Azure DevOps?

**Answer:**

**Blue-Green Deployment:**
- Two identical environments (Blue = live, Green = idle)
- Deploy to Green, test, then switch traffic from Blue to Green
- Instant rollback by switching back to Blue

**Blue-Green with Azure App Service (Deployment Slots):**
```yaml
steps:
  - task: AzureWebApp@1
    displayName: 'Deploy to Staging slot'
    inputs:
      azureSubscription: 'my-service-connection'
      appName: 'my-webapp'
      deployToSlotOrASE: true
      resourceGroupName: 'my-rg'
      slotName: 'staging'
      package: '$(Pipeline.Workspace)/**/*.zip'

  - task: AzureAppServiceManage@0
    displayName: 'Swap slots (staging → production)'
    inputs:
      azureSubscription: 'my-service-connection'
      action: 'Swap Slots'
      webAppName: 'my-webapp'
      resourceGroupName: 'my-rg'
      sourceSlot: 'staging'
      swapWithProduction: true
```

**Canary Deployment (gradual traffic shifting):**
- Send 10% of traffic to new version, monitor, gradually increase
- Use Azure Application Gateway or Traffic Manager for weighted routing
- Works well with AKS via Nginx ingress or Flagger

**Canary with AKS (using weights in NGINX ingress):**
```yaml
# Canary ingress annotation
annotations:
  nginx.ingress.kubernetes.io/canary: "true"
  nginx.ingress.kubernetes.io/canary-weight: "20"  # 20% traffic to new version
```

---

# PART 2: KUBERNETES (Questions 26–50)

---

## Q26. What is Kubernetes and what problems does it solve?

**Answer:**

**Kubernetes (K8s)** is an open-source container orchestration platform originally developed by Google, now maintained by the CNCF. It automates the deployment, scaling, scheduling, and management of containerized applications.

**Problems Kubernetes solves:**

| Problem | Kubernetes Solution |
|---------|-------------------|
| Manual container management | Automated deployment and lifecycle management |
| Application downtime | Self-healing — restarts failed containers automatically |
| Traffic spikes | Horizontal auto-scaling based on CPU/memory/custom metrics |
| Manual load balancing | Built-in Service load balancing and Ingress |
| Configuration management | ConfigMaps and Secrets decoupled from images |
| Rolling updates with zero downtime | Rolling update strategy with rollback support |
| Multi-host networking | Pod-to-pod communication across nodes |
| Storage management | Persistent Volumes and dynamic provisioning |

**Core architecture:**
```
Control Plane (Master)
├── API Server        — Central communication hub
├── etcd              — Distributed key-value store (cluster state)
├── Scheduler         — Assigns pods to nodes
└── Controller Manager — Maintains desired state

Worker Nodes
├── kubelet           — Node agent, ensures containers run
├── kube-proxy        — Network rules and load balancing
└── Container Runtime — Docker, containerd, CRI-O
```

---

## Q27. What is the difference between a Pod, ReplicaSet, Deployment, and StatefulSet?

**Answer:**

| Resource | Description | Use Case |
|----------|-------------|---------|
| **Pod** | Smallest deployable unit; one or more containers sharing network and storage | Single ephemeral task |
| **ReplicaSet** | Ensures N replicas of a pod are always running | Maintain pod count (rarely used directly) |
| **Deployment** | Manages ReplicaSets; supports rolling updates and rollbacks | Stateless applications |
| **StatefulSet** | Like Deployment but with stable network identity and persistent storage per pod | Databases, Kafka, Elasticsearch |
| **DaemonSet** | Ensures one pod per node (or per node subset) | Log collectors, monitoring agents |
| **Job** | Runs to completion; ensures N successful completions | Batch processing, data migration |
| **CronJob** | Runs Jobs on a schedule | Nightly backups, scheduled reports |

**Deployment vs StatefulSet — key differences:**

| Aspect | Deployment | StatefulSet |
|--------|-----------|-------------|
| Pod naming | Random (pod-xyz123) | Stable (pod-0, pod-1, pod-2) |
| Storage | Shared PVC or ephemeral | One PVC per pod (persistent) |
| Scaling order | Simultaneous | Sequential (0 → 1 → 2) |
| Identity | Interchangeable | Unique per pod |
| DNS | Single service DNS | Per-pod DNS (pod-0.svc.ns.svc.cluster.local) |
| Example | REST API server | MySQL, Redis cluster, ZooKeeper |

---

## Q28. Explain Kubernetes Services — ClusterIP, NodePort, LoadBalancer, and ExternalName.

**Answer:**

A **Service** is an abstraction that exposes a set of pods over a stable network endpoint. It load-balances traffic across pod replicas and decouples clients from pod IP addresses (which change on restarts).

**Service types:**

**1. ClusterIP (default)**
- Accessible only within the cluster
- Gets a stable virtual IP from the cluster's service CIDR
- Use case: Internal microservice communication

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  type: ClusterIP
  selector:
    app: backend
  ports:
    - port: 80
      targetPort: 8080
```

**2. NodePort**
- Exposes the service on each node's IP at a static port (30000–32767)
- Accessible from outside the cluster via `<NodeIP>:<NodePort>`
- Use case: Development/testing, on-premises clusters

**3. LoadBalancer**
- Creates a cloud load balancer (AWS ELB, Azure LB, GCP LB)
- Gets an external IP; routes traffic to NodePort → ClusterIP
- Use case: Production external-facing services

**4. ExternalName**
- Maps service to an external DNS name (no proxy, just CNAME)
- Use case: Access external services by a Kubernetes-native name

```yaml
spec:
  type: ExternalName
  externalName: my-database.example.com
```

**Traffic flow for LoadBalancer:**
```
Internet → Cloud LB (External IP) → NodePort (30080) → ClusterIP → Pod
```

---

## Q29. What is an Ingress and an Ingress Controller in Kubernetes?

**Answer:**

**Ingress** is a Kubernetes API object that defines HTTP/HTTPS routing rules — which domain names and URL paths route to which Services.

**Ingress Controller** is the actual software that implements those rules. Without a controller, Ingress objects have no effect. Popular options: NGINX Ingress Controller, Traefik, HAProxy, Istio Gateway.

**Ingress example:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - api.myapp.com
        - www.myapp.com
      secretName: myapp-tls-secret
  rules:
    - host: api.myapp.com
      http:
        paths:
          - path: /users
            pathType: Prefix
            backend:
              service:
                name: user-service
                port:
                  number: 80
          - path: /orders
            pathType: Prefix
            backend:
              service:
                name: order-service
                port:
                  number: 80
    - host: www.myapp.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend-service
                port:
                  number: 80
```

**Installing NGINX Ingress Controller on AKS:**
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.replicaCount=2
```

---

## Q30. What are ConfigMaps and Secrets in Kubernetes? How are they used?

**Answer:**

**ConfigMap** stores non-sensitive configuration data as key-value pairs, decoupled from container images. **Secret** stores sensitive data (passwords, tokens, certificates) in base64-encoded form.

**Creating a ConfigMap:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  DATABASE_HOST: "postgres.myapp.svc.cluster.local"
  DATABASE_PORT: "5432"
  LOG_LEVEL: "info"
  app.properties: |
    max.connections=100
    timeout.seconds=30
```

**Creating a Secret:**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
stringData:           # Kubernetes base64-encodes automatically
  DB_PASSWORD: "mysecretpassword"
  API_KEY: "abc123-secret-key"
```

**Using in a Pod — as environment variables:**
```yaml
spec:
  containers:
    - name: myapp
      image: myapp:1.0
      env:
        - name: DATABASE_HOST
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: DATABASE_HOST
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: DB_PASSWORD
      envFrom:
        - configMapRef:
            name: app-config   # Inject all keys as env vars
```

**Using as mounted volumes:**
```yaml
      volumeMounts:
        - name: config-vol
          mountPath: /etc/config
  volumes:
    - name: config-vol
      configMap:
        name: app-config
```

**Security note:** Kubernetes Secrets are base64-encoded, NOT encrypted at rest by default. Use **Azure Key Vault CSI Driver**, **HashiCorp Vault**, or enable **etcd encryption** for production-grade secret management.

---

## Q31. How does Horizontal Pod Autoscaling (HPA) work in Kubernetes?

**Answer:**

**HPA** automatically scales the number of pod replicas based on observed CPU/memory usage or custom metrics, ensuring the application handles load without over-provisioning resources.

**How it works:**
1. HPA queries the **Metrics Server** for current resource usage
2. Compares current usage to the target threshold
3. Calculates desired replicas: `desiredReplicas = currentReplicas × (currentMetric / desiredMetric)`
4. Scales up or down (with configurable stabilization windows to prevent thrashing)

**HPA manifest:**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 2
  maxReplicas: 20
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70   # Scale when avg CPU > 70%
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
```

**Custom metrics HPA (using KEDA or Prometheus Adapter):**
```yaml
  metrics:
    - type: External
      external:
        metric:
          name: azure_servicebus_queue_messages_active
          selector:
            matchLabels:
              queue: order-processing
        target:
          type: AverageValue
          averageValue: 100  # Scale up if queue depth > 100 messages
```

**HPA vs VPA vs Cluster Autoscaler:**

| Tool | What it scales | When to use |
|------|---------------|-------------|
| **HPA** | Pod replicas | Stateless workloads with variable traffic |
| **VPA** | Pod CPU/memory requests | Optimize resource allocation for pods |
| **Cluster Autoscaler** | Node count | When node resources are exhausted |

---

## Q32. What are Kubernetes namespaces and why are they important?

**Answer:**

**Namespaces** are virtual clusters within a physical Kubernetes cluster. They provide isolation, resource quotas, and access control boundaries between different teams, environments, or applications.

**Default namespaces:**

| Namespace | Purpose |
|-----------|---------|
| `default` | Default namespace for user resources if none specified |
| `kube-system` | Kubernetes control plane components (DNS, metrics-server, etc.) |
| `kube-public` | Publicly readable resources (cluster info) |
| `kube-node-lease` | Node heartbeat lease objects |

**Creating and using namespaces:**
```bash
# Create namespace
kubectl create namespace production
kubectl create namespace staging
kubectl create namespace development

# Deploy to specific namespace
kubectl apply -f deployment.yaml -n production

# Set default namespace for your context
kubectl config set-context --current --namespace=production

# View all resources across namespaces
kubectl get pods --all-namespaces
kubectl get pods -A
```

**Resource Quotas (per namespace):**
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: production-quota
  namespace: production
spec:
  hard:
    requests.cpu: "20"
    requests.memory: 40Gi
    limits.cpu: "40"
    limits.memory: 80Gi
    pods: "100"
    services: "20"
    persistentvolumeclaims: "30"
```

**Network isolation with NetworkPolicy:**
```yaml
# Only allow traffic within the same namespace
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-cross-namespace
  namespace: production
spec:
  podSelector: {}
  ingress:
    - from:
      - podSelector: {}   # Only from pods in same namespace
```

---

## Q33. Explain Kubernetes Persistent Volumes (PV), Persistent Volume Claims (PVC), and Storage Classes.

**Answer:**

Kubernetes separates storage provisioning from consumption through three resources:

**PersistentVolume (PV):** A piece of storage provisioned by an admin or dynamically. It's a cluster-level resource independent of any pod.

**PersistentVolumeClaim (PVC):** A request for storage by a user/pod. Specifies size, access mode, and storage class.

**StorageClass:** Defines the type of storage and its provisioner. Enables **dynamic provisioning** — PVs are created automatically when a PVC is created.

**Access modes:**

| Mode | Abbreviation | Description |
|------|-------------|-------------|
| ReadWriteOnce | RWO | Mounted by one node for read/write |
| ReadOnlyMany | ROX | Mounted by many nodes as read-only |
| ReadWriteMany | RWX | Mounted by many nodes for read/write (NFS, Azure Files) |
| ReadWriteOncePod | RWOP | Mounted by a single pod (K8s 1.22+) |

**StorageClass (Azure Disk):**
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: disk.csi.azure.com
parameters:
  skuName: Premium_LRS
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
```

**PVC:**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: fast-ssd
  resources:
    requests:
      storage: 50Gi
```

**Using PVC in a Pod:**
```yaml
spec:
  volumes:
    - name: postgres-storage
      persistentVolumeClaim:
        claimName: postgres-pvc
  containers:
    - name: postgres
      image: postgres:15
      volumeMounts:
        - mountPath: /var/lib/postgresql/data
          name: postgres-storage
```

---

## Q34. What is the difference between liveness, readiness, and startup probes?

**Answer:**

Probes are periodic health checks that Kubernetes runs against containers to determine their state and take action accordingly.

| Probe | Purpose | Action on Failure |
|-------|---------|------------------|
| **Liveness** | Is the container still running correctly? | Restart the container |
| **Readiness** | Is the container ready to serve traffic? | Remove from Service endpoints (no restart) |
| **Startup** | Has the container finished starting up? | Restart if startup takes too long |

**Probe types:**

| Type | Description |
|------|-------------|
| `httpGet` | HTTP GET request; success if status 200–399 |
| `tcpSocket` | TCP connection check; success if port opens |
| `exec` | Run command inside container; success if exit code 0 |
| `grpc` | gRPC health check protocol |

**Example with all three probes:**
```yaml
containers:
  - name: myapp
    image: myapp:1.0
    startupProbe:
      httpGet:
        path: /healthz/startup
        port: 8080
      failureThreshold: 30      # Allow 30 × 10s = 5 minutes to start
      periodSeconds: 10

    livenessProbe:
      httpGet:
        path: /healthz/live
        port: 8080
      initialDelaySeconds: 0   # Start checking immediately after startup probe passes
      periodSeconds: 10
      failureThreshold: 3      # Restart after 3 consecutive failures

    readinessProbe:
      httpGet:
        path: /healthz/ready
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 5
      failureThreshold: 3      # Remove from load balancer after 3 failures
      successThreshold: 2      # Require 2 successes to re-add to load balancer
```

**Real-world scenario:** A Spring Boot app takes 90 seconds to load application context. Use a startup probe with `failureThreshold: 18, periodSeconds: 10` (3 minutes). Liveness probe checks `/actuator/health/liveness`; readiness probe checks `/actuator/health/readiness`.

---

## Q35. What is RBAC in Kubernetes and how do you configure it?

**Answer:**

**Role-Based Access Control (RBAC)** controls who can perform what operations on which Kubernetes resources. It uses four objects: `Role`, `ClusterRole`, `RoleBinding`, and `ClusterRoleBinding`.

| Object | Scope | Purpose |
|--------|-------|---------|
| **Role** | Namespace | Defines permissions within a namespace |
| **ClusterRole** | Cluster-wide | Defines permissions across all namespaces or for non-namespaced resources |
| **RoleBinding** | Namespace | Grants a Role to a user/group/service account in a namespace |
| **ClusterRoleBinding** | Cluster-wide | Grants a ClusterRole to a user/group/service account |

**Example — Developer can read/exec pods in dev namespace:**
```yaml
# Role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer-role
  namespace: development
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["pods/exec"]
    verbs: ["create"]
  - apiGroups: ["apps"]
    resources: ["deployments"]
    verbs: ["get", "list", "watch", "update", "patch"]
---
# RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-binding
  namespace: development
subjects:
  - kind: User
    name: john.doe@company.com
    apiGroup: rbac.authorization.k8s.io
  - kind: Group
    name: dev-team
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer-role
  apiGroup: rbac.authorization.k8s.io
```

**Check permissions:**
```bash
kubectl auth can-i list pods --as=john.doe@company.com -n development
kubectl auth can-i delete deployments --as=john.doe@company.com -n production
```

---

## Q36. How do you perform a rolling update and rollback in Kubernetes?

**Answer:**

**Rolling update** gradually replaces old pods with new ones, ensuring zero downtime. Kubernetes replaces pods one-by-one (or in configurable batches).

**Deployment with rolling update strategy:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 6
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2        # Allow up to 2 extra pods during update
      maxUnavailable: 1  # Allow at most 1 pod to be unavailable
  template:
    spec:
      containers:
        - name: myapp
          image: myapp:2.0   # Updated image
```

**Update commands:**
```bash
# Update image (triggers rolling update)
kubectl set image deployment/myapp myapp=myapp:2.0 -n production

# Watch rollout status
kubectl rollout status deployment/myapp -n production

# Annotate the reason for auditing
kubectl annotate deployment myapp kubernetes.io/change-cause="Version 2.0 - added payment feature"

# View rollout history
kubectl rollout history deployment/myapp

# Rollback to previous version
kubectl rollout undo deployment/myapp

# Rollback to specific revision
kubectl rollout undo deployment/myapp --to-revision=2

# Pause/resume rollout
kubectl rollout pause deployment/myapp
kubectl rollout resume deployment/myapp
```

**Update strategies comparison:**

| Strategy | Description | Downtime | Use Case |
|----------|-------------|---------|----------|
| `RollingUpdate` | Gradual replacement | Zero | Most stateless apps |
| `Recreate` | Kill all, then create new | Yes | Dev environments, incompatible schema changes |

---

## Q37. What is a Kubernetes DaemonSet and when do you use it?

**Answer:**

A **DaemonSet** ensures that exactly one copy of a pod runs on each node in the cluster (or a subset of nodes matching a selector). When new nodes are added, DaemonSet pods are automatically scheduled on them; when nodes are removed, pods are garbage collected.

**Common use cases:**

| Use Case | Example Tools |
|----------|--------------|
| Log collection | Fluentd, Filebeat, Logstash |
| Monitoring/metrics | Prometheus Node Exporter, Datadog agent |
| Network plugins | Calico, Flannel, Weave |
| Storage drivers | Ceph, GlusterFS clients |
| Security agents | Falco, Sysdig, Twistlock |
| GPU device plugin | NVIDIA Device Plugin |

**DaemonSet manifest:**
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd-logging
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: fluentd
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      tolerations:
        - key: node-role.kubernetes.io/control-plane
          effect: NoSchedule          # Also run on control plane nodes
      containers:
        - name: fluentd
          image: fluent/fluentd-kubernetes-daemonset:v1.16-debian-elasticsearch8
          resources:
            limits:
              memory: 200Mi
              cpu: 100m
          volumeMounts:
            - name: varlog
              mountPath: /var/log
            - name: varlibdockercontainers
              mountPath: /var/lib/docker/containers
              readOnly: true
      volumes:
        - name: varlog
          hostPath:
            path: /var/log
        - name: varlibdockercontainers
          hostPath:
            path: /var/lib/docker/containers
```

---

## Q38. Explain Kubernetes Taints, Tolerations, and Node Affinity.

**Answer:**

These three mechanisms control which pods can be scheduled on which nodes.

**Taints** are properties applied to nodes that repel pods unless the pods explicitly tolerate the taint.

**Tolerations** are properties applied to pods that allow (but don't require) scheduling on tainted nodes.

**Node Affinity** is a more powerful mechanism for attracting pods to nodes based on node labels (preferred or required).

**Taints and Tolerations:**
```bash
# Taint a node (dedicated GPU node)
kubectl taint nodes gpu-node-01 hardware=gpu:NoSchedule
# NoSchedule: Pods without toleration won't be scheduled
# PreferNoSchedule: Avoid scheduling if possible
# NoExecute: Evict existing pods + don't schedule new ones
```

```yaml
# Pod tolerating the GPU taint
spec:
  tolerations:
    - key: "hardware"
      operator: "Equal"
      value: "gpu"
      effect: "NoSchedule"
  containers:
    - name: ml-training
      image: tensorflow/tensorflow:latest-gpu
```

**Node Affinity:**
```yaml
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: topology.kubernetes.io/zone
                operator: In
                values:
                  - eastus-1
                  - eastus-2
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 80
          preference:
            matchExpressions:
              - key: node-type
                operator: In
                values:
                  - high-memory
```

**Pod Anti-Affinity (spread replicas across nodes):**
```yaml
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - topologyKey: kubernetes.io/hostname
          labelSelector:
            matchLabels:
              app: myapp
```

---

## Q39. What is a Kubernetes NetworkPolicy and how does it work?

**Answer:**

A **NetworkPolicy** is a specification of how groups of pods communicate with each other and with external endpoints. By default, all pod-to-pod communication is allowed. NetworkPolicies restrict this.

**Important:** NetworkPolicy enforcement requires a CNI plugin that supports it (Calico, Cilium, Weave Net — NOT Flannel by default).

**Default deny all ingress:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: production
spec:
  podSelector: {}    # Applies to all pods
  policyTypes:
    - Ingress        # Deny all ingress; no ingress rules = deny all
```

**Allow only frontend to access backend:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-policy
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend           # Only frontend pods
        - namespaceSelector:
            matchLabels:
              name: monitoring        # Allow from monitoring namespace
      ports:
        - protocol: TCP
          port: 8080
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: postgres           # Only to database
      ports:
        - protocol: TCP
          port: 5432
    - to: []                          # Allow DNS
      ports:
        - protocol: UDP
          port: 53
```

---

## Q40. What is Helm and how does it simplify Kubernetes deployments?

**Answer:**

**Helm** is the package manager for Kubernetes. It uses **Charts** — collections of YAML templates — to define, install, upgrade, and manage Kubernetes applications with a single command.

**Core concepts:**

| Concept | Description |
|---------|-------------|
| **Chart** | Package of Kubernetes resources (templates + values) |
| **Release** | Instance of a chart installed in a cluster |
| **Repository** | Collection of charts (like apt/yum repos) |
| **Values** | Configuration parameters that override chart defaults |
| **Templates** | Go-template YAML files in the `templates/` directory |

**Chart structure:**
```
mychart/
├── Chart.yaml           # Chart metadata (name, version, description)
├── values.yaml          # Default configuration values
├── templates/
│   ├── deployment.yaml  # Kubernetes Deployment template
│   ├── service.yaml     # Service template
│   ├── ingress.yaml     # Ingress template
│   ├── _helpers.tpl     # Template helper functions
│   └── NOTES.txt        # Post-install notes shown to user
└── charts/              # Sub-charts (dependencies)
```

**Example values.yaml:**
```yaml
replicaCount: 3
image:
  repository: myacr.azurecr.io/myapp
  tag: "1.5.0"
  pullPolicy: IfNotPresent
service:
  type: ClusterIP
  port: 80
ingress:
  enabled: true
  host: api.myapp.com
resources:
  limits:
    cpu: 500m
    memory: 512Mi
```

**Common commands:**
```bash
# Add a repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install a chart
helm install my-postgres bitnami/postgresql \
  --namespace databases \
  --set auth.postgresPassword=secret123 \
  --set primary.persistence.size=100Gi

# Upgrade a release
helm upgrade my-postgres bitnami/postgresql \
  --set image.tag=15.3.0

# List releases
helm list -A

# Rollback
helm rollback my-postgres 1

# Uninstall
helm uninstall my-postgres -n databases

# Template rendering (dry run)
helm template my-release ./mychart -f production-values.yaml
```

---

## Q41. What is the Kubernetes resource model — requests vs limits?

**Answer:**

Every container in Kubernetes can specify resource **requests** and **limits** for CPU and memory.

| Field | Description |
|-------|-------------|
| **Request** | Guaranteed resources reserved by the scheduler for this container |
| **Limit** | Maximum resources the container can use |

**CPU:** Measured in cores or millicores (1000m = 1 CPU core). CPU is compressible — exceeding limit causes throttling.

**Memory:** Measured in bytes (Mi, Gi). Memory is incompressible — exceeding limit causes OOMKill (pod is restarted).

```yaml
resources:
  requests:
    cpu: "250m"       # 0.25 CPU core guaranteed
    memory: "256Mi"   # 256MB guaranteed
  limits:
    cpu: "500m"       # Can burst up to 0.5 CPU core
    memory: "512Mi"   # Will be OOMKilled if it exceeds 512MB
```

**Quality of Service (QoS) classes:**

| Class | Condition | Eviction Priority |
|-------|-----------|------------------|
| **Guaranteed** | requests == limits for all resources | Last to evict |
| **Burstable** | requests < limits (or only one set) | Evicted when under pressure |
| **BestEffort** | No requests or limits set | First to evict |

**LimitRange** — set default requests/limits for a namespace:
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
  namespace: development
spec:
  limits:
    - type: Container
      default:
        cpu: "500m"
        memory: "512Mi"
      defaultRequest:
        cpu: "100m"
        memory: "128Mi"
      max:
        cpu: "2"
        memory: "4Gi"
```

---

## Q42. What is Kubernetes etcd and why is it critical?

**Answer:**

**etcd** is a distributed, consistent key-value store that serves as the backing store for all Kubernetes cluster data. Everything about the cluster state is stored in etcd: pod definitions, service configurations, secrets, configmaps, RBAC policies, and more.

**Why it's critical:**
- If etcd is unavailable, the API server cannot read or write cluster state
- New pods cannot be scheduled, existing workloads continue running but cannot be managed
- Loss of etcd without backup = total cluster data loss

**etcd in a HA setup:**
```
etcd cluster: 3 or 5 members (odd number for quorum)
Quorum = ⌊n/2⌋ + 1
  3-member cluster: tolerates 1 failure
  5-member cluster: tolerates 2 failures
```

**Backup and restore:**
```bash
# Backup etcd (run on control plane node)
ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-snapshot.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# Verify snapshot
etcdctl snapshot status /backup/etcd-snapshot.db --write-out=table

# Restore from backup
ETCDCTL_API=3 etcdctl snapshot restore /backup/etcd-snapshot.db \
  --data-dir=/var/lib/etcd-from-backup \
  --name=master \
  --initial-cluster=master=https://127.0.0.1:2380 \
  --initial-advertise-peer-urls=https://127.0.0.1:2380
```

**Best practices:**
- Back up etcd every 6 hours (or before major changes)
- Store backups in Azure Blob Storage or similar external storage
- Test restores regularly in a non-production cluster

---

## Q43. What is Kubernetes Ingress TLS termination and how do you configure it with cert-manager?

**Answer:**

**TLS termination** at the Ingress level means HTTPS traffic is decrypted at the Ingress Controller; backend pods receive plain HTTP traffic. This centralizes certificate management.

**cert-manager** is a Kubernetes add-on that automates the issuance and renewal of TLS certificates from Let's Encrypt, HashiCorp Vault, Venafi, or self-signed CAs.

**Installation:**
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.yaml
```

**ClusterIssuer (Let's Encrypt):**
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: admin@myapp.com
    privateKeySecretRef:
      name: letsencrypt-prod-key
    solvers:
      - http01:
          ingress:
            class: nginx
```

**Ingress with auto-TLS:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp-ingress
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - api.myapp.com
      secretName: myapp-tls     # cert-manager creates and manages this Secret
  rules:
    - host: api.myapp.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: myapp-service
                port:
                  number: 80
```

cert-manager automatically creates a `Certificate` resource, performs the ACME challenge, and stores the certificate in the referenced secret. It renews the certificate 30 days before expiry.

---

## Q44. What is Kubernetes Pod Disruption Budget (PDB)?

**Answer:**

A **Pod Disruption Budget (PDB)** limits the number of pods that can be voluntarily disrupted (drained, evicted) at the same time. It protects application availability during cluster maintenance operations like node drains, cluster upgrades, or rolling updates.

**Voluntary vs involuntary disruptions:**
- **Voluntary:** Node drain, cluster upgrade, deleting a pod, HPA scale-down
- **Involuntary:** Node hardware failure, OOMKill — PDB does NOT protect against these

**PDB manifest:**
```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: myapp-pdb
spec:
  selector:
    matchLabels:
      app: myapp
  minAvailable: 3      # Always keep at least 3 pods running
  # OR
  maxUnavailable: 1    # Allow at most 1 pod down at a time (not both)
```

**Real-world example:**
- 6 replicas of `myapp`
- PDB: `maxUnavailable: 2`
- During `kubectl drain node-01`, Kubernetes evicts pods one by one
- If 2 are already being evicted, the drain waits before evicting more

**Best practice:** Always define a PDB for production workloads before cluster upgrades. AKS node pool upgrades respect PDBs.

```bash
# Check PDB status
kubectl get pdb -n production
# NAME         MIN AVAILABLE   MAX UNAVAILABLE   ALLOWED DISRUPTIONS   AGE
# myapp-pdb    3               N/A               1                     5d
```

---

## Q45. How do you monitor a Kubernetes cluster using Prometheus and Grafana?

**Answer:**

The standard Kubernetes monitoring stack uses **Prometheus** for metrics collection/alerting and **Grafana** for visualization.

**Architecture:**
```
Kubernetes Components
  (kubelet, API server, etcd, node-exporter)
        ↓ scrape metrics
    Prometheus
        ↓ query
      Grafana (dashboards)
        ↓ alerts
AlertManager → PagerDuty / Slack / Teams
```

**Installation using kube-prometheus-stack Helm chart:**
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set grafana.adminPassword=admin123 \
  --set alertmanager.config.global.slack_api_url=https://hooks.slack.com/... \
  --set prometheus.prometheusSpec.retention=30d \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=100Gi
```

**Key metrics to monitor:**

| Category | Metric | Alert Threshold |
|----------|--------|----------------|
| **Node** | CPU utilization | > 85% |
| **Node** | Memory utilization | > 85% |
| **Node** | Disk usage | > 80% |
| **Pod** | Restart count | > 5 in 10 min |
| **Pod** | OOMKilled events | Any |
| **Deployment** | Available replicas < desired | Any |
| **API Server** | Request error rate | > 5% |
| **etcd** | Leader election changes | Frequent |

**ServiceMonitor (tell Prometheus to scrape your app):**
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: myapp-monitor
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: myapp
  namespaceSelector:
    matchNames:
      - production
  endpoints:
    - port: metrics
      path: /metrics
      interval: 30s
```

---

## Q46. Explain Kubernetes Init Containers and Sidecar Containers.

**Answer:**

**Init Containers** run to completion before the main application containers start. Each init container must succeed before the next one runs. They're used for initialization logic that shouldn't be in the main container.

**Sidecar Containers** (stable in K8s 1.29+) run alongside the main container throughout its lifecycle, providing supporting functions like logging, proxying, and monitoring.

**Init Container use cases:**
- Wait for a dependency (database, external API) to be ready
- Run database migrations before the app starts
- Clone a Git repo or download configuration files
- Set up permissions on shared volumes

**Init Containers example:**
```yaml
spec:
  initContainers:
    - name: wait-for-db
      image: busybox:1.35
      command: ['sh', '-c', 
        'until nc -z postgres-service 5432; do echo "Waiting for DB..."; sleep 3; done; echo "DB ready!"']
    
    - name: run-migrations
      image: myapp:latest
      command: ['python', 'manage.py', 'migrate']
      env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: DATABASE_URL

  containers:
    - name: myapp
      image: myapp:latest
      ports:
        - containerPort: 8000
```

**Sidecar Containers (log shipping example):**
```yaml
  containers:
    - name: myapp
      image: myapp:latest
      volumeMounts:
        - name: logs
          mountPath: /var/log/app

    - name: log-shipper            # Sidecar
      image: fluent/fluentd:latest
      volumeMounts:
        - name: logs
          mountPath: /var/log/app  # Reads logs from shared volume
  
  volumes:
    - name: logs
      emptyDir: {}
```

---

## Q47. What is Kubernetes CRD (Custom Resource Definition)?

**Answer:**

A **Custom Resource Definition (CRD)** extends the Kubernetes API by defining new resource types. Once a CRD is created, you can use `kubectl` to create, read, update, and delete custom resources just like built-in resources (Pods, Deployments).

**CRDs are the foundation of the Kubernetes Operator pattern.**

**Example — Creating a CRD for a Database resource:**
```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: databases.mycompany.io
spec:
  group: mycompany.io
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                engine:
                  type: string
                  enum: [postgres, mysql, mongodb]
                version:
                  type: string
                storage:
                  type: string
                replicas:
                  type: integer
                  minimum: 1
                  maximum: 5
  scope: Namespaced
  names:
    plural: databases
    singular: database
    kind: Database
    shortNames:
      - db
```

**Using the custom resource:**
```yaml
apiVersion: mycompany.io/v1
kind: Database
metadata:
  name: prod-postgres
spec:
  engine: postgres
  version: "15.3"
  storage: 100Gi
  replicas: 3
```

**Popular tools built on CRDs:**
- cert-manager (Certificate, ClusterIssuer)
- Argo CD (Application, AppProject)
- Prometheus Operator (ServiceMonitor, PrometheusRule)
- Istio (VirtualService, DestinationRule, Gateway)

---

## Q48. What is Kubernetes Cluster Autoscaler and how does it work?

**Answer:**

The **Cluster Autoscaler (CA)** automatically adjusts the number of nodes in a cluster based on pod scheduling demands and node utilization.

**Scale-up trigger:**
- A pod fails to be scheduled due to insufficient resources
- CA simulates pod scheduling and determines which node pool to expand
- Requests cloud provider to add a new node
- Node becomes available, pod is scheduled

**Scale-down trigger:**
- Node resource utilization < 50% for 10+ minutes
- All pods on the node can be rescheduled elsewhere
- CA drains the node and requests cloud provider to remove it

**AKS Cluster Autoscaler configuration:**
```bash
# Enable autoscaler on an existing node pool
az aks nodepool update \
  --resource-group myRG \
  --cluster-name myAKS \
  --name agentpool \
  --enable-cluster-autoscaler \
  --min-count 2 \
  --max-count 20
```

**Autoscaler annotations to control behavior:**
```yaml
# Prevent specific pods from being evicted during scale-down
annotations:
  cluster-autoscaler.kubernetes.io/safe-to-evict: "false"

# Prevent node from being scaled down
kubectl annotate node mynode cluster-autoscaler.kubernetes.io/scale-down-disabled=true
```

**CA + HPA interaction:**
```
High traffic → HPA creates more pod replicas
→ Pods pending (no node capacity)
→ Cluster Autoscaler adds nodes
→ Pods scheduled
→ Traffic reduces → HPA scales down pods
→ Nodes underutilized → CA removes nodes
```

---

## Q49. How do you implement zero-downtime deployments in Kubernetes?

**Answer:**

Zero-downtime deployments require a combination of properly configured Kubernetes features:

**1. Rolling Update Strategy (already covered)**

**2. Proper Readiness Probes**
Pods must only receive traffic when truly ready. Without readiness probes, pods receive traffic immediately after starting, potentially before the app is ready.

**3. preStop hook + terminationGracePeriodSeconds**
When a pod is terminated, it may be removed from the Service endpoints before finishing in-flight requests.
```yaml
spec:
  terminationGracePeriodSeconds: 60
  containers:
    - name: myapp
      lifecycle:
        preStop:
          exec:
            command: ["/bin/sh", "-c", "sleep 15"]  # Allow load balancer to drain
```

**4. PodDisruptionBudget**
Prevents too many pods from being unavailable simultaneously.

**5. minReadySeconds**
Waits N seconds after a pod becomes ready before considering the rollout step complete.
```yaml
spec:
  minReadySeconds: 30
```

**6. Pod Anti-Affinity**
Spread replicas across nodes to prevent single-node failures from taking down the service.

**Complete zero-downtime deployment checklist:**
```yaml
spec:
  replicas: 3
  minReadySeconds: 30
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0       # Never reduce available pods
  template:
    spec:
      terminationGracePeriodSeconds: 60
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - topologyKey: kubernetes.io/hostname
      containers:
        - name: myapp
          readinessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 5
          lifecycle:
            preStop:
              exec:
                command: ["sleep", "15"]
```

---

## Q50. What is a Kubernetes Operator and how does it work?

**Answer:**

A **Kubernetes Operator** is a software extension that uses custom resources (CRDs) and custom controllers to automate the management of complex, stateful applications. Operators encode operational knowledge (how to deploy, scale, backup, upgrade) into software.

**The Operator pattern:**
```
CRD defines the desired state
  ↓
Custom Controller watches for CRD changes
  ↓
Controller reconciles actual state → desired state
  ↓
Controller creates/modifies/deletes Kubernetes resources
```

**Real-world examples:**

| Operator | Manages |
|----------|---------|
| **PostgreSQL Operator** (Zalando) | PostgreSQL clusters, backups, failover |
| **Prometheus Operator** | Prometheus instances, ServiceMonitors, AlertingRules |
| **Strimzi** | Apache Kafka clusters on Kubernetes |
| **Argo CD** | GitOps deployments |
| **Elasticsearch ECK** | Elasticsearch and Kibana clusters |

**Building an operator with Operator SDK:**
```bash
# Initialize operator project
operator-sdk init --domain mycompany.io --repo github.com/myco/myoperator

# Create API (CRD)
operator-sdk create api --group apps --version v1 --kind MyDatabase --resource --controller

# Implement reconcile logic in controllers/mydatabase_controller.go
# Build and deploy
make docker-build docker-push IMG=myacr.azurecr.io/myoperator:v0.1.0
make deploy IMG=myacr.azurecr.io/myoperator:v0.1.0
```

---

# PART 3: TERRAFORM (Questions 51–75)

---

## Q51. What is Terraform and what are its key benefits?

**Answer:**

**Terraform** is an open-source Infrastructure as Code (IaC) tool by HashiCorp that enables you to define, provision, and manage cloud infrastructure using a declarative configuration language called **HCL (HashiCorp Configuration Language)**.

**Key benefits:**

| Benefit | Description |
|---------|-------------|
| **Declarative** | Define the desired end state; Terraform figures out how to achieve it |
| **Multi-cloud** | Single tool for AWS, Azure, GCP, Kubernetes, databases, and 1000+ providers |
| **State management** | Tracks infrastructure state to detect drift and plan changes |
| **Idempotent** | Running the same plan multiple times produces the same result |
| **Plan before apply** | Preview all changes before executing them |
| **Version controlled** | Infrastructure defined in code → reviewable, auditable, versioned |
| **Modular** | Reusable modules for common patterns |
| **Ecosystem** | Terraform Registry has thousands of public modules |

**Terraform workflow:**
```
Write HCL → terraform init → terraform plan → terraform apply → terraform destroy
```

**Basic example (Azure VM):**
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatestorage"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "my-app-rg"
  location = "East US"
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

---

## Q52. Explain the Terraform state file and how to manage it remotely.

**Answer:**

The **Terraform state file** (`terraform.tfstate`) is a JSON file that maps Terraform resource definitions to real-world infrastructure resources. Terraform uses it to determine what changes need to be made during `terraform plan` and `terraform apply`.

**What state tracks:**
- Resource IDs and attributes of every managed resource
- Dependencies between resources
- Metadata (Terraform version, provider versions)

**Why remote state is essential:**
- Local state files cannot be shared across team members
- Local state is lost if the machine fails
- Remote state supports state locking (prevents concurrent apply operations)

**Remote state in Azure Blob Storage:**
```bash
# Create storage for state
az group create --name terraform-state-rg --location eastus
az storage account create --name tfstatemystorage --resource-group terraform-state-rg --sku Standard_LRS
az storage container create --name tfstate --account-name tfstatemystorage
```

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatemystorage"
    container_name       = "tfstate"
    key                  = "prod/main.terraform.tfstate"
  }
}
```

**State commands:**
```bash
terraform state list                        # List all resources in state
terraform state show azurerm_aks_cluster.main  # Show state of a specific resource
terraform state mv azurerm_resource_group.old azurerm_resource_group.new  # Rename resource in state
terraform state rm azurerm_resource_group.main  # Remove from state (doesn't destroy resource)
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/my-rg  # Import existing resource
```

**State locking:** Azure Blob Storage uses blob leases for locking. If a `terraform apply` is in progress and another starts, the second one waits or fails with a lock error. Use `-lock=false` cautiously in emergencies.

---

## Q53. What are Terraform modules and how do you create them?

**Answer:**

A **Terraform module** is a self-contained package of Terraform configurations that encapsulates a reusable infrastructure component. Modules promote DRY (Don't Repeat Yourself) principles and standardize infrastructure patterns across teams.

**Module structure:**
```
modules/
└── aks-cluster/
    ├── main.tf          # Resource definitions
    ├── variables.tf     # Input variables
    ├── outputs.tf       # Output values
    └── README.md        # Documentation
```

**Module example (AKS cluster module):**

`modules/aks-cluster/variables.tf`:
```hcl
variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "East US"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
  default     = 3
  validation {
    condition     = var.node_count >= 1 && var.node_count <= 100
    error_message = "Node count must be between 1 and 100."
  }
}

variable "node_vm_size" {
  type    = string
  default = "Standard_D4s_v3"
}
```

`modules/aks-cluster/main.tf`:
```hcl
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name       = "system"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    enable_auto_scaling = true
    min_count  = 1
    max_count  = var.node_count * 3
  }

  identity {
    type = "SystemAssigned"
  }
}
```

`modules/aks-cluster/outputs.tf`:
```hcl
output "cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}
```

**Using the module:**
```hcl
module "prod_aks" {
  source       = "./modules/aks-cluster"
  cluster_name = "prod-aks"
  location     = "East US"
  node_count   = 5
  node_vm_size = "Standard_D8s_v3"
}

# Use module outputs
output "prod_cluster_id" {
  value = module.prod_aks.cluster_id
}
```

---

## Q54. What is the difference between terraform plan, apply, destroy, and refresh?

**Answer:**

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize working directory, download providers and modules |
| `terraform validate` | Validate configuration syntax and logic without querying APIs |
| `terraform fmt` | Format HCL code to canonical style |
| `terraform plan` | Show what changes will be made (no actual changes) |
| `terraform apply` | Execute the plan and create/modify/destroy infrastructure |
| `terraform destroy` | Destroy all resources managed by current state |
| `terraform refresh` | Update state file to match actual infrastructure (deprecated in favor of `apply -refresh-only`) |
| `terraform output` | Show output values from state |
| `terraform graph` | Generate visual dependency graph |

**Plan output symbols:**
```
+ create   — New resource will be created
~ update   — Existing resource will be updated in-place
- destroy  — Resource will be destroyed
-/+ replace — Resource will be destroyed and recreated
<= read    — Data source will be read
```

**Advanced apply options:**
```bash
# Save plan to file (for CI/CD pipelines — apply exactly what was planned)
terraform plan -out=tfplan
terraform apply tfplan

# Target specific resources (use with caution)
terraform apply -target=azurerm_aks_cluster.main

# Auto-approve (for automation; skip interactive confirmation)
terraform apply -auto-approve

# Pass variables
terraform apply -var="environment=production" -var="node_count=10"
terraform apply -var-file="production.tfvars"
```

---

## Q55. What are Terraform data sources?

**Answer:**

**Data sources** allow Terraform to read information from existing resources or APIs that are managed outside of the current Terraform configuration. They let you reference pre-existing infrastructure without managing it.

**Use cases:**
- Reference an existing resource group, VNet, or subscription
- Look up the latest VM image ID
- Get current Azure subscription details
- Query existing secrets from Key Vault

**Examples:**
```hcl
# Get current Azure subscription
data "azurerm_subscription" "current" {}

# Get existing resource group (not managed by this Terraform)
data "azurerm_resource_group" "shared" {
  name = "shared-infra-rg"
}

# Get latest Ubuntu image
data "azurerm_platform_image" "ubuntu" {
  location  = "East US"
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts-gen2"
}

# Get existing Key Vault
data "azurerm_key_vault" "main" {
  name                = "myapp-keyvault"
  resource_group_name = data.azurerm_resource_group.shared.name
}

# Get secret from Key Vault
data "azurerm_key_vault_secret" "db_password" {
  name         = "database-password"
  key_vault_id = data.azurerm_key_vault.main.id
}

# Use data source in resource
resource "azurerm_kubernetes_cluster" "main" {
  location            = data.azurerm_resource_group.shared.location
  resource_group_name = data.azurerm_resource_group.shared.name
  # ...
}
```

---

## Q56. Explain Terraform variables — types, validation, and best practices.

**Answer:**

**Variable types:**

```hcl
variable "region" {
  type    = string
  default = "East US"
}

variable "node_count" {
  type    = number
  default = 3
}

variable "enable_monitoring" {
  type    = bool
  default = true
}

variable "allowed_ips" {
  type    = list(string)
  default = ["10.0.0.0/8", "192.168.0.0/16"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Production"
    Team        = "Platform"
  }
}

variable "vm_config" {
  type = object({
    size        = string
    disk_gb     = number
    os          = string
  })
  default = {
    size    = "Standard_D4s_v3"
    disk_gb = 128
    os      = "Ubuntu"
  }
}
```

**Variable validation:**
```hcl
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

variable "node_count" {
  type = number
  validation {
    condition     = var.node_count >= 1 && var.node_count <= 50
    error_message = "Node count must be between 1 and 50."
  }
}
```

**Variable precedence (lowest → highest):**
```
1. Default values in variables.tf
2. terraform.tfvars file
3. *.auto.tfvars files (alphabetical order)
4. -var-file flag
5. -var flag
6. TF_VAR_* environment variables (highest priority)
```

**Environment variable:**
```bash
export TF_VAR_node_count=10
export TF_VAR_db_password="supersecret"
terraform apply
```

**Sensitive variables (don't appear in plan output):**
```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

---

## Q57. What are Terraform locals and when should you use them?

**Answer:**

**Locals** are named expressions that simplify complex expressions, avoid repetition, and give meaningful names to intermediate values. Unlike variables, locals are computed internally and cannot be set from outside the configuration.

```hcl
locals {
  # Computed values
  environment     = var.environment
  cluster_name    = "${var.project}-${var.environment}-aks"
  resource_prefix = "${var.project}-${var.environment}"

  # Complex expression simplified
  common_tags = merge(var.default_tags, {
    Environment   = var.environment
    Project       = var.project
    ManagedBy     = "Terraform"
    LastUpdated   = timestamp()
  })

  # Conditional logic
  node_count = var.environment == "production" ? 10 : 3

  # Map transformation
  subnet_ids = {
    for name, subnet in azurerm_subnet.subnets :
    name => subnet.id
  }

  # Whether to enable features based on environment
  enable_ddos_protection = contains(["production", "staging"], var.environment)
}

resource "azurerm_resource_group" "main" {
  name     = "${local.resource_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_kubernetes_cluster" "main" {
  name = local.cluster_name
  default_node_pool {
    node_count = local.node_count
  }
}
```

**Locals vs Variables:**
| Aspect | Variables | Locals |
|--------|-----------|--------|
| Set from outside | Yes (CLI, env vars, tfvars) | No |
| Use for | User input, configuration | Internal computation, reuse |
| Appear in plan | Yes | No |

---

## Q58. What are Terraform workspaces and how do they work?

**Answer:**

**Workspaces** allow you to maintain multiple separate state files from the same Terraform configuration. This enables you to manage multiple environments (dev, staging, production) using the same code.

```bash
# List workspaces
terraform workspace list
# * default
#   staging
#   production

# Create a new workspace
terraform workspace new staging
terraform workspace new production

# Switch workspace
terraform workspace select production

# Show current workspace
terraform workspace show

# Delete a workspace (must switch away first)
terraform workspace delete staging
```

**Using workspace in configuration:**
```hcl
locals {
  env_config = {
    dev = {
      node_count = 2
      vm_size    = "Standard_D2s_v3"
      sku_tier   = "Free"
    }
    staging = {
      node_count = 3
      vm_size    = "Standard_D4s_v3"
      sku_tier   = "Paid"
    }
    production = {
      node_count = 10
      vm_size    = "Standard_D8s_v3"
      sku_tier   = "Paid"
    }
  }
  config = local.env_config[terraform.workspace]
}

resource "azurerm_kubernetes_cluster" "main" {
  name = "aks-${terraform.workspace}"
  default_node_pool {
    node_count = local.config.node_count
    vm_size    = local.config.vm_size
  }
  sku_tier = local.config.sku_tier
}
```

**Workspace vs separate state files:**
- **Workspaces:** Same config, different state files — good for ephemeral environments (feature branches)
- **Separate directories/repos:** Different configs AND state — recommended for long-lived environments with different configurations (production should be strictly isolated)

---

## Q59. What are Terraform provisioners and when should you use them?

**Answer:**

**Provisioners** execute scripts or commands on a local machine or remote resource after it's created or before it's destroyed. They are a last resort in Terraform — most operations should be done with native provider resources.

**Types of provisioners:**

| Provisioner | Executes on | Use case |
|-------------|------------|---------|
| `local-exec` | Machine running Terraform | Run local scripts, send notifications |
| `remote-exec` | Remote resource (via SSH/WinRM) | Bootstrap VMs, install software |
| `file` | Remote resource | Copy files to the remote machine |

**local-exec example:**
```hcl
resource "azurerm_kubernetes_cluster" "main" {
  # ... cluster config ...

  provisioner "local-exec" {
    command = <<-EOT
      az aks get-credentials \
        --resource-group ${azurerm_resource_group.main.name} \
        --name ${azurerm_kubernetes_cluster.main.name} \
        --overwrite-existing
      kubectl apply -f ./base-manifests/
    EOT
  }
}
```

**remote-exec example:**
```hcl
resource "azurerm_linux_virtual_machine" "main" {
  # ... VM config ...

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "azureuser"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip_address
    }
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx"
    ]
  }
}
```

**When NOT to use provisioners:**
- Don't install software — use VM extensions, cloud-init, or Packer instead
- Don't configure applications — use Ansible, Chef, or Puppet
- Provisioners make Terraform non-idempotent and harder to debug

---

## Q60. How do you manage Terraform across multiple environments in a team?

**Answer:**

**Recommended directory structure (Terragrunt or plain Terraform):**
```
infrastructure/
├── modules/
│   ├── networking/
│   ├── aks-cluster/
│   └── monitoring/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── dev.tfvars
│   ├── staging/
│   │   ├── main.tf
│   │   └── staging.tfvars
│   └── production/
│       ├── main.tf
│       └── production.tfvars
└── global/
    └── backend-setup/
        └── main.tf    # Storage account for state
```

**CI/CD workflow for Terraform:**
```
PR opened → terraform plan (post results as PR comment)
PR approved + merged → terraform apply (auto-approve for dev)
                     → manual approval required for prod
```

**Team best practices:**

| Practice | Implementation |
|----------|---------------|
| Remote state with locking | Azure Blob Storage backend |
| State per environment | Separate state files/containers |
| Peer review for changes | Branch protection + terraform plan in PR |
| Secret management | Key Vault data sources; TF_VAR_ env vars |
| Module versioning | Pin module versions (`source = "git::...?ref=v1.2.0"`) |
| Provider version pinning | `version = "~> 3.80"` in required_providers |
| Automated testing | Terratest, Checkov (policy), tfsec (security) |

---

## Q61. What is Terraform import and when do you use it?

**Answer:**

`terraform import` brings existing infrastructure resources under Terraform management. It adds them to the state file without modifying the actual resource. After importing, you must also write the HCL configuration manually.

**When to use:**
- Resources were created manually (click-ops) and you want to manage them with Terraform
- Migrating from one Terraform state to another
- Recovering from state file corruption

**Import process:**

**Step 1: Write the resource configuration (HCL)**
```hcl
resource "azurerm_resource_group" "main" {
  name     = "existing-rg"
  location = "East US"
}
```

**Step 2: Import the resource**
```bash
# Get the resource ID from Azure Portal or CLI
az group show --name existing-rg --query id -o tsv
# /subscriptions/12345-abc/resourceGroups/existing-rg

terraform import azurerm_resource_group.main \
  /subscriptions/12345-abc/resourceGroups/existing-rg
```

**Step 3: Verify**
```bash
terraform plan  # Should show "No changes. Infrastructure is up-to-date."
```

**Import block (Terraform 1.5+) — declarative approach:**
```hcl
import {
  to = azurerm_resource_group.main
  id = "/subscriptions/12345-abc/resourceGroups/existing-rg"
}

# terraform plan -generate-config-out=generated.tf
# Terraform auto-generates the resource configuration!
```

---

## Q62. What are Terraform outputs and how are they used?

**Answer:**

**Outputs** expose values from your Terraform configuration. They're useful for displaying important information after `apply`, passing data between modules, and exposing values to automation pipelines.

```hcl
output "cluster_id" {
  description = "The resource ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "cluster_fqdn" {
  description = "Fully qualified domain name of the cluster API server"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "kube_config" {
  description = "Raw kubeconfig file content"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true   # Not printed to console; still stored in state
}

output "node_resource_group" {
  description = "Auto-created resource group containing AKS nodes"
  value       = azurerm_kubernetes_cluster.main.node_resource_group
}
```

**Accessing outputs:**
```bash
# Show all outputs
terraform output

# Get specific output
terraform output cluster_fqdn

# Get sensitive output
terraform output -raw kube_config > ~/.kube/config

# Get output as JSON for scripting
terraform output -json | jq '.cluster_id.value'
```

**Referencing outputs across modules:**
```hcl
module "networking" {
  source = "./modules/networking"
}

module "aks" {
  source     = "./modules/aks-cluster"
  subnet_id  = module.networking.aks_subnet_id    # Cross-module reference
  vnet_id    = module.networking.vnet_id
}
```

**In Azure DevOps pipelines:**
```yaml
- script: |
    cd infrastructure/environments/production
    terraform init
    terraform apply -auto-approve
    echo "##vso[task.setvariable variable=AKS_NAME;isOutput=true]$(terraform output -raw cluster_name)"
  name: terraformApply
```

---

## Q63. How do you handle Terraform state drift?

**Answer:**

**State drift** occurs when the actual infrastructure state differs from what Terraform's state file records. This happens when someone makes manual changes in the console, or a resource is modified by an external process.

**Detecting drift:**
```bash
# Refresh state and show plan (detects drift without applying)
terraform plan -refresh-only

# This shows what Terraform would need to update to match reality
# e.g., if someone manually changed node count from 3 to 5 in Azure Portal
```

**Handling drift — three approaches:**

**1. Reconcile (Terraform wins):**
```bash
terraform apply  # Re-apply desired state, overwriting manual changes
```

**2. Accept drift (Update Terraform config to match reality):**
```bash
terraform apply -refresh-only  # Update state to match reality
# Then update your HCL to match the new desired state
```

**3. Import the change:**
If someone added a new resource manually, import it:
```bash
terraform import azurerm_storage_account.new /subscriptions/.../storageAccounts/newaccount
```

**Preventing drift:**
- Use Azure Policy to deny manual changes to tagged "Terraform-managed" resources
- Enable Azure Monitor alerts on resource changes in Terraform-managed resource groups
- Run `terraform plan` on a schedule (via Azure DevOps scheduled pipeline) and alert on drift
- Implement strict RBAC — only the Terraform service principal can modify infrastructure

---

## Q64. What is Terragrunt and how does it extend Terraform?

**Answer:**

**Terragrunt** is a thin wrapper around Terraform that adds features for managing multiple Terraform modules, avoiding code repetition, and handling dependencies between stacks.

**Problems Terragrunt solves:**

| Problem | Terragrunt Solution |
|---------|-------------------|
| Backend config repeated in every module | `generate` block creates backend.tf dynamically |
| Provider config repeated | `generate` block for provider config |
| Module dependencies | `dependency` block with automatic ordering |
| DRY principle for inputs | Hierarchical `terragrunt.hcl` inheritance |
| Running multiple modules | `terragrunt run-all` command |

**Terragrunt folder structure:**
```
infrastructure/
├── terragrunt.hcl          # Root config (backend, provider)
├── dev/
│   ├── terragrunt.hcl      # Dev env overrides
│   ├── networking/
│   │   └── terragrunt.hcl  # Module config
│   └── aks/
│       └── terragrunt.hcl
└── production/
    ├── terragrunt.hcl
    └── aks/
        └── terragrunt.hcl
```

**Root terragrunt.hcl:**
```hcl
locals {
  env    = basename(dirname(get_terragrunt_dir()))
  region = "East US"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatestorage"
    container_name       = "tfstate"
    key                  = "${local.env}/terraform.tfstate"
  }
}
EOF
}
```

**Module terragrunt.hcl with dependency:**
```hcl
include "root" {
  path = find_in_parent_folders()
}

dependency "networking" {
  config_path = "../networking"
}

terraform {
  source = "../../../../modules//aks-cluster"
}

inputs = {
  subnet_id  = dependency.networking.outputs.aks_subnet_id
  node_count = 5
}
```

---

## Q65. How do you write Terraform configuration for an AKS cluster with best practices?

**Answer:**

```hcl
# variables.tf
variable "environment"      { type = string }
variable "location"         { type = string; default = "East US" }
variable "project"          { type = string }
variable "kubernetes_version" { type = string; default = "1.28.5" }

# main.tf
locals {
  prefix = "${var.project}-${var.environment}"
  tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${local.prefix}-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "${local.prefix}-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.240.0.0/16"]
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${local.prefix}-aks"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${local.prefix}-aks"
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.environment == "production" ? "Paid" : "Free"

  default_node_pool {
    name                = "system"
    node_count          = 3
    vm_size             = "Standard_D4s_v3"
    vnet_subnet_id      = azurerm_subnet.aks.id
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 10
    os_disk_size_gb     = 100
    os_disk_type        = "Managed"
    type                = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type" = "system"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    service_cidr      = "10.0.0.0/16"
    dns_service_ip    = "10.0.0.10"
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  tags = local.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "workload" {
  name                  = "workload"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_D8s_v3"
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 50
  vnet_subnet_id        = azurerm_subnet.aks.id
  node_labels = {
    "nodepool-type" = "workload"
  }
  tags = local.tags
}
```

---

## Q66. Explain Terraform's `for_each` and `count` meta-arguments.

**Answer:**

Both `count` and `for_each` allow creating multiple instances of a resource from a single block.

**count — simple numeric repetition:**
```hcl
variable "resource_groups" {
  type    = list(string)
  default = ["dev-rg", "staging-rg", "prod-rg"]
}

resource "azurerm_resource_group" "envs" {
  count    = length(var.resource_groups)
  name     = var.resource_groups[count.index]
  location = "East US"
}

# Reference: azurerm_resource_group.envs[0], [1], [2]
```

**for_each — map/set based repetition (recommended):**
```hcl
variable "resource_groups" {
  type = map(object({
    location = string
    tags     = map(string)
  }))
  default = {
    dev = {
      location = "East US"
      tags     = { Environment = "dev" }
    }
    production = {
      location = "West US 2"
      tags     = { Environment = "production" }
    }
  }
}

resource "azurerm_resource_group" "envs" {
  for_each = var.resource_groups
  name     = "${each.key}-rg"
  location = each.value.location
  tags     = each.value.tags
}

# Reference: azurerm_resource_group.envs["dev"], ["production"]
```

**Why for_each is better than count:**
```
With count: delete index 1 → resources [1] and [2] shift down → destroys and recreates [2]
With for_each: delete "staging" key → only "staging" resource is destroyed, others untouched
```

**Dynamic blocks (for_each inside a resource block):**
```hcl
variable "firewall_rules" {
  type = list(object({
    name     = string
    priority = number
    port     = number
  }))
}

resource "azurerm_network_security_group" "main" {
  dynamic "security_rule" {
    for_each = var.firewall_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = tostring(security_rule.value.port)
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
```

---

## Q67. What is the `depends_on` meta-argument in Terraform?

**Answer:**

`depends_on` creates explicit dependency relationships between resources or modules. Terraform normally infers dependencies from resource references, but `depends_on` handles cases where the dependency is implicit (e.g., an IAM role must exist before a resource is created, but the role isn't directly referenced).

**Implicit dependency (preferred — no depends_on needed):**
```hcl
resource "azurerm_subnet" "main" {
  virtual_network_name = azurerm_virtual_network.main.name  # Implicit dependency
  # Terraform knows VNet must exist first
}
```

**Explicit dependency with depends_on:**
```hcl
# AKS needs the role assignment to exist before creation
# but doesn't directly reference the role assignment
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

resource "helm_release" "app" {
  name       = "myapp"
  chart      = "./charts/myapp"
  depends_on = [
    azurerm_role_assignment.acr_pull,     # App can't pull images until this exists
    azurerm_kubernetes_cluster.main
  ]
}
```

**Module depends_on:**
```hcl
module "app_deployment" {
  source = "./modules/app"
  depends_on = [
    module.networking,
    module.aks_cluster
  ]
}
```

**Caution:** Overusing `depends_on` makes plans slower and can mask architectural issues. Always prefer implicit references where possible.

---

## Q68. How do you implement Terraform security scanning and policy enforcement?

**Answer:**

**tfsec — Static analysis for security issues:**
```bash
# Install
brew install tfsec  # or: docker pull aquasec/tfsec

# Run
tfsec .

# Example findings:
# HIGH: Resource uses plain HTTP (should use HTTPS)
# MEDIUM: Storage account allows public access
# LOW: No logging enabled on Key Vault
```

**Checkov — Policy-as-code (CIS, PCI-DSS, SOC2 checks):**
```bash
pip install checkov
checkov -d . --framework terraform

# Run specific check
checkov -d . --check CKV_AZURE_7  # Check: Ensure AKS RBAC is enabled
```

**Custom Checkov policy:**
```python
from checkov.common.models.enums import CheckCategories, CheckResult
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck

class AKSRBACEnabled(BaseResourceCheck):
    def __init__(self):
        name = "Ensure AKS cluster has RBAC enabled"
        id = "CKV_CUSTOM_AKS_001"
        supported_resources = ['azurerm_kubernetes_cluster']
        categories = [CheckCategories.SECURITY]
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        rbac = conf.get("role_based_access_control_enabled", [True])
        if rbac == [True] or rbac is True:
            return CheckResult.PASSED
        return CheckResult.FAILED
```

**Azure Policy + Terraform (OPA/Sentinel for Terraform Enterprise):**
- Block resources without required tags
- Enforce naming conventions
- Require specific SKUs in production

**Pre-commit hooks:**
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tfsec
      - id: terraform_checkov
```

---

## Q69. What is the difference between `terraform.tfvars` and variables passed via `-var-file`?

**Answer:**

Both mechanisms supply values to Terraform variables, but they differ in loading behavior:

| Mechanism | Auto-loaded | Usage |
|-----------|------------|-------|
| `terraform.tfvars` | Yes (automatically) | Default values for all runs |
| `*.auto.tfvars` | Yes (alphabetically) | Automatically loaded variable files |
| `-var-file=file.tfvars` | No (explicitly specified) | Environment-specific overrides |
| `-var "key=value"` | No | Quick overrides, CI/CD pipelines |
| `TF_VAR_*` env variables | No | CI/CD, secrets injection |

**Recommended structure for multiple environments:**
```
infrastructure/
├── variables.tf          # Variable declarations
├── main.tf               # Resources
├── terraform.tfvars      # Common defaults (non-sensitive)
├── dev.tfvars            # Dev-specific values
├── staging.tfvars        # Staging-specific values
└── production.tfvars     # Production-specific values
```

**terraform.tfvars (common defaults):**
```hcl
project  = "myapp"
location = "East US"
tags = {
  ManagedBy = "Terraform"
  Team      = "Platform"
}
```

**production.tfvars (env-specific):**
```hcl
environment      = "production"
node_count       = 10
vm_size          = "Standard_D8s_v3"
kubernetes_version = "1.28.5"
enable_monitoring = true
```

**Usage:**
```bash
terraform apply -var-file="production.tfvars" -var="db_password=${DB_PASSWORD}"
```

---

## Q70. How does Terraform handle resource lifecycle? Explain lifecycle meta-arguments.

**Answer:**

The `lifecycle` block customizes how Terraform creates, updates, and destroys resources.

```hcl
resource "azurerm_kubernetes_cluster" "main" {
  # ... config ...

  lifecycle {
    # Prevent accidental destruction of critical resources
    prevent_destroy = true

    # Ignore changes to specific attributes (managed outside Terraform)
    ignore_changes = [
      tags["LastDeployedBy"],     # Changed by deployment pipeline
      default_node_pool[0].node_count,  # Managed by Cluster Autoscaler
      kubernetes_version          # Upgraded via Azure Portal
    ]

    # Create new resource BEFORE destroying the old one
    # Useful to avoid downtime during replacement
    create_before_destroy = true

    # Custom conditions (Terraform 1.2+)
    precondition {
      condition     = var.environment != "production" || var.node_count >= 3
      error_message = "Production environments must have at least 3 nodes."
    }

    postcondition {
      condition     = self.fqdn != ""
      error_message = "AKS cluster FQDN should not be empty after creation."
    }
  }
}
```

**When to use each:**

| Meta-argument | Use case |
|---------------|---------|
| `prevent_destroy` | Protect production databases, state storage |
| `ignore_changes` | Attributes managed by external systems (autoscaling, tagging bots) |
| `create_before_destroy` | Resources that must not have downtime (ACM certificates, load balancers) |
| `precondition` | Validate inputs before resource creation |
| `postcondition` | Validate outputs after resource creation |

---

## Q71. What is `terraform fmt` and `terraform validate`? When do you run them?

**Answer:**

**`terraform fmt`:** Formats HCL code to canonical style — consistent indentation (2 spaces), aligned equals signs, proper spacing. Non-destructive — only changes formatting, not logic.

```bash
terraform fmt             # Format files in current directory
terraform fmt -recursive  # Format all subdirectories
terraform fmt -check      # Check if files are formatted (exit 1 if not) — for CI
terraform fmt -diff       # Show what would be changed
```

**`terraform validate`:** Checks configuration for syntax errors and internal consistency without accessing remote APIs or state. Catches:
- Typos in resource types or attribute names
- Missing required attributes
- Invalid attribute values
- Circular dependencies

```bash
terraform validate
# Success! The configuration is valid.
# OR
# Error: Missing required argument
# The argument "name" is required, but no definition was found.
```

**CI/CD integration (Azure DevOps YAML):**
```yaml
steps:
  - script: terraform fmt -check -recursive
    displayName: 'Check Terraform formatting'
    failOnStderr: true

  - script: terraform validate
    displayName: 'Validate Terraform configuration'

  - script: tfsec . --format json > tfsec-results.json
    displayName: 'Security scan with tfsec'

  - task: PublishBuildArtifacts@1
    inputs:
      pathToPublish: tfsec-results.json
      artifactName: security-scan-results
```

---

## Q72. How do you manage Terraform provider versions and lock files?

**Answer:**

Terraform uses a `.terraform.lock.hcl` file to lock provider versions, ensuring consistent behavior across different machines and CI/CD runs.

**Specifying provider versions:**
```hcl
terraform {
  required_version = ">= 1.6.0"   # Minimum Terraform version

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"    # Allow 3.80.x but not 4.x
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0, < 3.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
```

**Version constraint operators:**

| Operator | Meaning |
|----------|---------|
| `= 3.80.0` | Exactly this version |
| `!= 3.70.0` | Not this version |
| `>= 3.70.0` | At least this version |
| `~> 3.80` | `>= 3.80.0, < 4.0.0` (pessimistic constraint) |
| `~> 3.80.0` | `>= 3.80.0, < 3.81.0` |

**Lock file (.terraform.lock.hcl):**
- Created automatically on `terraform init`
- Contains exact versions and hashes of providers
- Must be committed to version control
- Update with: `terraform init -upgrade`

```bash
# Initialize with existing lock file (respects locked versions)
terraform init

# Upgrade to latest matching versions and update lock file
terraform init -upgrade

# Add platform-specific hashes (for teams on different OS)
terraform providers lock \
  -platform=linux_amd64 \
  -platform=darwin_arm64 \
  -platform=windows_amd64
```

---

## Q73. How do you use Terraform with Azure DevOps in a CI/CD pipeline?

**Answer:**

```yaml
# azure-pipelines.yml
trigger:
  branches:
    include:
      - main
  paths:
    include:
      - infrastructure/**

pr:
  branches:
    include:
      - main

variables:
  - group: terraform-azure-credentials
  - name: TF_VERSION
    value: '1.7.0'
  - name: WORKING_DIR
    value: 'infrastructure/environments/production'

pool:
  vmImage: 'ubuntu-latest'

stages:
  # ─── Stage 1: Validate & Plan (runs on PR and push to main) ───
  - stage: TerraformPlan
    displayName: 'Terraform Plan'
    jobs:
      - job: Plan
        steps:
          - task: TerraformInstaller@0
            inputs:
              terraformVersion: $(TF_VERSION)

          - task: TerraformTaskV4@4
            displayName: 'Init'
            inputs:
              provider: 'azurerm'
              command: 'init'
              workingDirectory: $(WORKING_DIR)
              backendServiceArm: 'terraform-service-connection'
              backendAzureRmResourceGroupName: 'terraform-state-rg'
              backendAzureRmStorageAccountName: 'tfstatestorage'
              backendAzureRmContainerName: 'tfstate'
              backendAzureRmKey: 'production.terraform.tfstate'

          - task: TerraformTaskV4@4
            displayName: 'Validate'
            inputs:
              provider: 'azurerm'
              command: 'validate'
              workingDirectory: $(WORKING_DIR)

          - task: TerraformTaskV4@4
            displayName: 'Plan'
            name: terraformPlan
            inputs:
              provider: 'azurerm'
              command: 'plan'
              workingDirectory: $(WORKING_DIR)
              environmentServiceNameAzureRM: 'terraform-service-connection'
              commandOptions: '-out=$(Pipeline.Workspace)/tfplan'

          - publish: $(Pipeline.Workspace)/tfplan
            artifact: terraform-plan

  # ─── Stage 2: Apply (only on main branch, requires approval) ───
  - stage: TerraformApply
    displayName: 'Terraform Apply'
    dependsOn: TerraformPlan
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: Apply
        environment: production   # Environment with manual approval configured
        strategy:
          runOnce:
            deploy:
              steps:
                - download: current
                  artifact: terraform-plan

                - task: TerraformInstaller@0
                  inputs:
                    terraformVersion: $(TF_VERSION)

                - task: TerraformTaskV4@4
                  displayName: 'Init'
                  inputs:
                    provider: 'azurerm'
                    command: 'init'
                    workingDirectory: $(WORKING_DIR)
                    backendServiceArm: 'terraform-service-connection'
                    backendAzureRmResourceGroupName: 'terraform-state-rg'
                    backendAzureRmStorageAccountName: 'tfstatestorage'
                    backendAzureRmContainerName: 'tfstate'
                    backendAzureRmKey: 'production.terraform.tfstate'

                - task: TerraformTaskV4@4
                  displayName: 'Apply'
                  inputs:
                    provider: 'azurerm'
                    command: 'apply'
                    workingDirectory: $(WORKING_DIR)
                    environmentServiceNameAzureRM: 'terraform-service-connection'
                    commandOptions: '$(Pipeline.Workspace)/terraform-plan/tfplan'
```

---

## Q74. What is the Terraform Registry and how do you use public modules?

**Answer:**

The **Terraform Registry** (registry.terraform.io) is a centralized repository of providers and modules. Public modules are free to use and cover common infrastructure patterns.

**Using a public module from the registry:**
```hcl
# AKS module from Azure/aks/azurerm
module "aks" {
  source  = "Azure/aks/azurerm"
  version = "7.5.0"          # Always pin module versions

  resource_group_name = azurerm_resource_group.main.name
  cluster_name        = "my-aks-cluster"
  prefix              = "myapp"
  
  agents_size  = "Standard_D4s_v3"
  agents_count = 3
  
  network_plugin = "azure"
  network_policy = "calico"
  
  enable_auto_scaling = true
  agents_min_count    = 2
  agents_max_count    = 20
  
  log_analytics_workspace_enabled = true
  
  depends_on = [azurerm_resource_group.main]
}
```

**Private module registry:** Terraform Enterprise/Cloud supports a private module registry for your organization. Modules are versioned with semantic versioning and accessible only to organization members.

**Finding good modules:**
- Check download count and GitHub stars
- Look for recent updates and active maintenance
- Review open issues and PRs
- Always read the README and source code before using in production
- Pin to specific versions, never use `latest`

---

## Q75. How do you test Terraform configurations?

**Answer:**

**Testing pyramid for Terraform:**
```
      ╔══════════════╗
      ║   E2E Tests  ║  (Slow, expensive — test real infra)
      ╠══════════════╣
      ║  Integration ║  (Terratest — provision & verify)
      ╠══════════════╣
      ║  Unit Tests  ║  (terraform validate, tflint, checkov)
      ╚══════════════╝
```

**1. Static analysis (fastest):**
```bash
terraform fmt -check        # Formatting
terraform validate          # Syntax/logic
tflint --recursive          # Best practices, deprecations
tfsec .                     # Security
checkov -d .                # Policy compliance
```

**2. Terratest (Go-based integration testing):**
```go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/gruntwork-io/terratest/modules/azure"
    "github.com/stretchr/testify/assert"
)

func TestAKSModule(t *testing.T) {
    t.Parallel()

    opts := &terraform.Options{
        TerraformDir: "../modules/aks-cluster",
        Vars: map[string]interface{}{
            "environment":  "test",
            "cluster_name": "test-aks",
            "node_count":   1,
        },
    }

    defer terraform.Destroy(t, opts)  // Always clean up
    terraform.InitAndApply(t, opts)

    clusterID := terraform.Output(t, opts, "cluster_id")
    assert.NotEmpty(t, clusterID)

    // Verify the cluster exists in Azure
    exists := azure.AKSClusterExists(t, "test-aks", "test-rg", "")
    assert.True(t, exists)
}
```

**3. Terraform native testing (Terraform 1.6+):**
```hcl
# tests/aks_module.tftest.hcl
variables {
  environment  = "test"
  node_count   = 1
}

run "basic_aks_creation" {
  command = plan

  assert {
    condition     = azurerm_kubernetes_cluster.main.sku_tier == "Free"
    error_message = "Test environment should use Free tier"
  }

  assert {
    condition     = length(azurerm_kubernetes_cluster.main.default_node_pool) == 1
    error_message = "Should have exactly one default node pool"
  }
}
```

---

# PART 4: AZURE DEVOPS YAML PIPELINES (Questions 76–100)

---

## Q76. What is the structure of an Azure DevOps YAML pipeline?

**Answer:**

A YAML pipeline is defined in a `.yml` file committed to your repository. It follows a hierarchical structure:

```
Pipeline
├── trigger / pr             — What triggers the pipeline
├── variables                — Pipeline-wide variables
├── pool                     — Where pipeline runs (agent)
├── stages (optional)        — High-level groupings
│   └── Stage
│       └── jobs             — Units of work
│           └── Job
│               └── steps    — Individual actions
│                   ├── script — Run a shell/PowerShell command
│                   ├── task   — Pre-built Azure DevOps task
│                   └── bash / pwsh / checkout
└── parameters               — Runtime parameters with types
```

**Full example:**
```yaml
trigger:
  branches:
    include:
      - main
      - release/*
  paths:
    exclude:
      - docs/**
      - '*.md'

pr:
  branches:
    include:
      - main

parameters:
  - name: runTests
    displayName: 'Run unit tests?'
    type: boolean
    default: true
  - name: environment
    displayName: 'Target environment'
    type: string
    default: dev
    values:
      - dev
      - staging
      - production

variables:
  - group: global-secrets
  - name: buildConfiguration
    value: 'Release'
  - name: imageTag
    value: '$(Build.BuildNumber)'

pool:
  vmImage: 'ubuntu-latest'

stages:
  - stage: Build
    displayName: 'Build & Test'
    jobs:
      - job: BuildJob
        displayName: 'Build Application'
        steps:
          - checkout: self
            fetchDepth: 0

          - script: dotnet build --configuration $(buildConfiguration)
            displayName: 'Build'

          - ${{ if eq(parameters.runTests, true) }}:
            - script: dotnet test --collect:"XPlat Code Coverage"
              displayName: 'Test'

  - stage: Deploy
    displayName: 'Deploy to ${{ parameters.environment }}'
    dependsOn: Build
    jobs:
      - deployment: DeployJob
        environment: ${{ parameters.environment }}
        strategy:
          runOnce:
            deploy:
              steps:
                - script: echo "Deploying to ${{ parameters.environment }}"
```

---

## Q77. How do triggers work in Azure DevOps YAML pipelines?

**Answer:**

Triggers define when a pipeline runs automatically. There are four types:

**1. CI Trigger (Push trigger):**
```yaml
trigger:
  branches:
    include:
      - main
      - develop
      - feature/*
      - release/*
    exclude:
      - release/legacy-*
  paths:
    include:
      - src/**
      - Dockerfile
    exclude:
      - docs/**
      - '**/*.md'
  tags:
    include:
      - v*           # Trigger on any version tag
```

**2. PR Trigger:**
```yaml
pr:
  branches:
    include:
      - main
      - develop
  paths:
    include:
      - src/**
  drafts: false      # Don't trigger for draft PRs
```

**3. Scheduled Trigger (Cron):**
```yaml
schedules:
  - cron: "0 2 * * 1-5"    # 2:00 AM UTC Mon-Fri
    displayName: 'Nightly build'
    branches:
      include:
        - main
    always: true             # Run even if no code changes
  
  - cron: "0 18 * * 5"      # Friday 6 PM
    displayName: 'Weekend cleanup'
    branches:
      include:
        - main
    always: false
```

**4. Pipeline Trigger (downstream pipelines):**
```yaml
resources:
  pipelines:
    - pipeline: upstream-build
      source: 'My Build Pipeline'
      trigger:
        branches:
          include:
            - main
```

**Disabling triggers:**
```yaml
trigger: none    # Manual only
pr: none         # No PR triggers
```

---

## Q78. How do you use variables in Azure DevOps YAML pipelines?

**Answer:**

**Defining variables:**
```yaml
variables:
  # Inline variables
  - name: buildConfiguration
    value: 'Release'
  - name: imageTag
    value: '$(Build.BuildNumber)'

  # Variable group (from Library)
  - group: production-secrets

  # Variable template file
  - template: variables/common.yml

  # Conditional variable
  - name: environment
    ${{ if eq(variables['Build.SourceBranch'], 'refs/heads/main') }}:
      value: production
    ${{ else }}:
      value: development
```

**Predefined system variables (commonly used):**

| Variable | Value |
|----------|-------|
| `Build.BuildId` | Unique build ID (integer) |
| `Build.BuildNumber` | Build number (e.g., 20240115.3) |
| `Build.SourceBranch` | Full branch ref (refs/heads/main) |
| `Build.SourceBranchName` | Branch name (main) |
| `Build.Repository.Name` | Repository name |
| `System.DefaultWorkingDirectory` | Agent working directory |
| `Pipeline.Workspace` | Pipeline workspace directory |
| `Agent.Name` | Name of the agent running the job |

**Setting variables at runtime (output variables):**
```yaml
steps:
  - bash: |
      IMAGE_TAG=$(git rev-parse --short HEAD)
      echo "##vso[task.setvariable variable=IMAGE_TAG]$IMAGE_TAG"
      echo "##vso[task.setvariable variable=IMAGE_TAG;isOutput=true]$IMAGE_TAG"
    name: setTag
    displayName: 'Set image tag from git SHA'

  - bash: echo "Image tag is $(IMAGE_TAG)"
    displayName: 'Use variable'
```

**Passing variables between stages:**
```yaml
stages:
  - stage: Build
    jobs:
      - job: BuildJob
        steps:
          - bash: echo "##vso[task.setvariable variable=imageTag;isOutput=true]$(Build.BuildNumber)"
            name: setTag

  - stage: Deploy
    dependsOn: Build
    variables:
      imageTag: $[ stageDependencies.Build.BuildJob.outputs['setTag.imageTag'] ]
    jobs:
      - job: DeployJob
        steps:
          - bash: echo "Deploying image tag $(imageTag)"
```

---

## Q79. How do you implement reusable YAML templates in Azure DevOps?

**Answer:**

Templates allow you to extract reusable pipeline steps, jobs, stages, or variables into separate files and reference them from pipelines.

**Step template — `templates/build-steps.yml`:**
```yaml
parameters:
  - name: buildConfiguration
    type: string
    default: 'Release'
  - name: projectPath
    type: string

steps:
  - task: DotNetCoreCLI@2
    displayName: 'Restore packages'
    inputs:
      command: 'restore'
      projects: '${{ parameters.projectPath }}'

  - task: DotNetCoreCLI@2
    displayName: 'Build ${{ parameters.buildConfiguration }}'
    inputs:
      command: 'build'
      projects: '${{ parameters.projectPath }}'
      arguments: '--configuration ${{ parameters.buildConfiguration }} --no-restore'

  - task: DotNetCoreCLI@2
    displayName: 'Run tests'
    inputs:
      command: 'test'
      projects: '**/*Tests.csproj'
      arguments: '--configuration ${{ parameters.buildConfiguration }} --collect:"XPlat Code Coverage"'
```

**Job template — `templates/deploy-job.yml`:**
```yaml
parameters:
  - name: environment
    type: string
  - name: serviceConnection
    type: string
  - name: imageTag
    type: string

jobs:
  - deployment: Deploy_${{ parameters.environment }}
    displayName: 'Deploy to ${{ parameters.environment }}'
    environment: ${{ parameters.environment }}
    strategy:
      runOnce:
        deploy:
          steps:
            - task: KubernetesManifest@0
              inputs:
                action: 'deploy'
                connectionType: 'azureResourceManager'
                azureSubscriptionConnection: '${{ parameters.serviceConnection }}'
                manifests: '$(Pipeline.Workspace)/manifests/*.yaml'
```

**Stage template — `templates/environment-stage.yml`:**
```yaml
parameters:
  - name: environment
    type: string
  - name: dependsOn
    type: string
    default: ''

stages:
  - stage: Deploy_${{ parameters.environment }}
    displayName: 'Deploy to ${{ parameters.environment }}'
    dependsOn: ${{ parameters.dependsOn }}
    jobs:
      - template: deploy-job.yml
        parameters:
          environment: ${{ parameters.environment }}
```

**Main pipeline using templates:**
```yaml
trigger:
  - main

stages:
  - stage: Build
    jobs:
      - job: Build
        steps:
          - template: templates/build-steps.yml
            parameters:
              buildConfiguration: 'Release'
              projectPath: 'src/MyApp.csproj'

  - template: templates/environment-stage.yml
    parameters:
      environment: dev
      dependsOn: Build

  - template: templates/environment-stage.yml
    parameters:
      environment: production
      dependsOn: Deploy_dev
```

---

## Q80. How do you publish and download build artifacts in YAML pipelines?

**Answer:**

**Publishing artifacts (pipeline artifacts — recommended):**
```yaml
steps:
  - task: DotNetCoreCLI@2
    inputs:
      command: 'publish'
      publishWebProjects: true
      arguments: '--output $(Build.ArtifactStagingDirectory)'

  - task: PublishPipelineArtifact@1
    displayName: 'Publish build artifact'
    inputs:
      targetPath: '$(Build.ArtifactStagingDirectory)'
      artifact: 'drop'
      publishLocation: 'pipeline'
```

**Downloading artifacts:**
```yaml
steps:
  - task: DownloadPipelineArtifact@2
    inputs:
      buildType: 'current'
      artifactName: 'drop'
      targetPath: '$(Pipeline.Workspace)/drop'

  - script: ls -la $(Pipeline.Workspace)/drop
```

**Download from a different pipeline:**
```yaml
resources:
  pipelines:
    - pipeline: buildPipeline
      source: 'My Build Pipeline'
      trigger: true

steps:
  - task: DownloadPipelineArtifact@2
    inputs:
      buildType: 'specific'
      project: 'MyProject'
      definition: 42
      buildVersionToDownload: 'latestFromBranch'
      branchName: 'refs/heads/main'
      artifactName: 'drop'
      targetPath: '$(Pipeline.Workspace)/drop'
```

**Docker image as artifact (push to ACR):**
```yaml
steps:
  - task: Docker@2
    displayName: 'Build and push to ACR'
    inputs:
      command: 'buildAndPush'
      containerRegistry: 'my-acr-service-connection'
      repository: 'myapp'
      dockerfile: 'Dockerfile'
      tags: |
        $(Build.BuildNumber)
        latest
```

---

## Q81. How do you implement matrix builds in Azure DevOps YAML?

**Answer:**

Matrix builds run the same job multiple times with different variable combinations — useful for testing across multiple OS, runtime versions, or configurations simultaneously.

```yaml
jobs:
  - job: TestMatrix
    displayName: 'Test on ${{ matrix.name }}'
    strategy:
      matrix:
        Linux_Python39:
          imageName: 'ubuntu-latest'
          pythonVersion: '3.9'
          name: 'Linux / Python 3.9'
        Linux_Python311:
          imageName: 'ubuntu-latest'
          pythonVersion: '3.11'
          name: 'Linux / Python 3.11'
        Windows_Python311:
          imageName: 'windows-latest'
          pythonVersion: '3.11'
          name: 'Windows / Python 3.11'
        MacOS_Python311:
          imageName: 'macos-latest'
          pythonVersion: '3.11'
          name: 'macOS / Python 3.11'
      maxParallel: 4       # All 4 run in parallel
    pool:
      vmImage: $(imageName)
    steps:
      - task: UsePythonVersion@0
        inputs:
          versionSpec: '$(pythonVersion)'
      
      - script: |
          python -m pip install -r requirements.txt
          python -m pytest tests/ --junitxml=test-results.xml
        displayName: 'Run tests'
      
      - task: PublishTestResults@2
        condition: always()
        inputs:
          testResultsFiles: 'test-results.xml'
          testRunTitle: '$(name)'
```

**Node.js multi-version matrix:**
```yaml
strategy:
  matrix:
    node16:
      nodeVersion: '16.x'
    node18:
      nodeVersion: '18.x'
    node20:
      nodeVersion: '20.x'
  maxParallel: 3
```

---

## Q82. How do you use conditions in Azure DevOps YAML pipelines?

**Answer:**

Conditions control whether a step, job, or stage runs based on expressions evaluated at runtime.

**Step conditions:**
```yaml
steps:
  # Run only on main branch
  - script: ./deploy.sh
    condition: eq(variables['Build.SourceBranch'], 'refs/heads/main')

  # Run only if previous step failed
  - script: ./send-failure-alert.sh
    condition: failed()

  # Always run (even if previous steps failed) — for cleanup
  - task: PublishTestResults@2
    condition: always()

  # Succeeded and on main branch
  - script: ./release.sh
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))

  # Custom variable check
  - script: ./integration-tests.sh
    condition: eq(variables['runIntegrationTests'], 'true')

  # Not a PR build
  - script: ./push-docker.sh
    condition: ne(variables['Build.Reason'], 'PullRequest')
```

**Stage conditions:**
```yaml
stages:
  - stage: DeployProduction
    condition: |
      and(
        succeeded('DeployStaging'),
        eq(variables['Build.SourceBranch'], 'refs/heads/main'),
        ne(variables['Build.Reason'], 'PullRequest')
      )
```

**Compile-time conditions (template expressions `${{ }}`)**
```yaml
steps:
  - ${{ if eq(parameters.environment, 'production') }}:
    - script: echo "Running production-specific steps"
    - task: AzureCLI@2
      inputs:
        scriptType: bash
        scriptLocation: inlineScript
        inlineScript: az resource lock create --name no-delete --lock-type CanNotDelete ...

  - ${{ each service in parameters.services }}:
    - script: docker build -t $(registry)/${{ service }}:$(tag) ${{ service }}/
      displayName: 'Build ${{ service }}'
```

**Built-in condition functions:**

| Function | Description |
|----------|-------------|
| `succeeded()` | All previous steps/jobs succeeded |
| `failed()` | At least one previous step failed |
| `always()` | Run regardless of previous state |
| `canceled()` | Pipeline was canceled |
| `succeededOrFailed()` | Ran (not canceled) |
| `eq(a, b)` | Equals comparison |
| `ne(a, b)` | Not equals |
| `and(a, b)` | Logical AND |
| `or(a, b)` | Logical OR |
| `not(a)` | Logical NOT |
| `contains(a, b)` | String contains |
| `startsWith(a, b)` | String starts with |

---

## Q83. How do you build and push Docker images using Azure DevOps YAML pipelines?

**Answer:**

```yaml
trigger:
  branches:
    include:
      - main
  paths:
    include:
      - src/**
      - Dockerfile

variables:
  containerRegistry: 'myacr.azurecr.io'
  imageRepository: 'myapp'
  dockerfilePath: '$(Build.SourcesDirectory)/Dockerfile'
  tag: '$(Build.BuildNumber)'
  acrServiceConnection: 'my-acr-service-connection'

stages:
  - stage: Build
    displayName: 'Build & Push Docker Image'
    jobs:
      - job: Docker
        pool:
          vmImage: 'ubuntu-latest'
        steps:
          - checkout: self

          - task: Docker@2
            displayName: 'Login to ACR'
            inputs:
              command: 'login'
              containerRegistry: $(acrServiceConnection)

          - task: Docker@2
            displayName: 'Build image'
            inputs:
              command: 'build'
              repository: $(imageRepository)
              dockerfile: $(dockerfilePath)
              containerRegistry: $(acrServiceConnection)
              tags: |
                $(tag)
                latest
              arguments: >
                --build-arg BUILD_NUMBER=$(Build.BuildNumber)
                --build-arg GIT_COMMIT=$(Build.SourceVersion)
                --cache-from $(containerRegistry)/$(imageRepository):latest

          - script: |
              docker run --rm $(containerRegistry)/$(imageRepository):$(tag) \
                python -c "import app; print('Import OK')"
            displayName: 'Smoke test image'

          - task: Docker@2
            displayName: 'Push to ACR'
            inputs:
              command: 'push'
              repository: $(imageRepository)
              containerRegistry: $(acrServiceConnection)
              tags: |
                $(tag)
                latest

          - task: PublishPipelineArtifact@1
            displayName: 'Save image tag'
            inputs:
              targetPath: '$(Build.ArtifactStagingDirectory)'
              artifact: 'docker-metadata'

  - stage: ScanImage
    displayName: 'Security Scan'
    dependsOn: Build
    jobs:
      - job: Trivy
        steps:
          - script: |
              docker run --rm \
                -v /var/run/docker.sock:/var/run/docker.sock \
                aquasec/trivy:latest image \
                --exit-code 1 \
                --severity HIGH,CRITICAL \
                $(containerRegistry)/$(imageRepository):$(tag)
            displayName: 'Trivy vulnerability scan'
```

---

## Q84. How do you deploy to Azure Kubernetes Service (AKS) using YAML pipelines?

**Answer:**

```yaml
stages:
  - stage: DeployToAKS
    displayName: 'Deploy to AKS'
    jobs:
      - deployment: AKSDeploy
        displayName: 'Deploy to production AKS'
        environment:
          name: production
          resourceType: Kubernetes
          resourceName: my-aks-cluster
        strategy:
          runOnce:
            deploy:
              steps:
                # Method 1: Use KubernetesManifest task
                - task: KubernetesManifest@1
                  displayName: 'Create image pull secret'
                  inputs:
                    action: 'createSecret'
                    connectionType: 'azureResourceManager'
                    azureSubscriptionConnection: 'my-azure-service-connection'
                    azureResourceGroup: 'myapp-rg'
                    kubernetesCluster: 'my-aks-cluster'
                    namespace: 'production'
                    secretType: 'dockerRegistry'
                    secretName: 'acr-secret'
                    dockerRegistryEndpoint: 'my-acr-service-connection'

                # Method 2: Deploy manifests from repo
                - task: KubernetesManifest@1
                  displayName: 'Deploy to AKS'
                  inputs:
                    action: 'deploy'
                    connectionType: 'azureResourceManager'
                    azureSubscriptionConnection: 'my-azure-service-connection'
                    azureResourceGroup: 'myapp-rg'
                    kubernetesCluster: 'my-aks-cluster'
                    namespace: 'production'
                    manifests: |
                      $(Pipeline.Workspace)/manifests/deployment.yaml
                      $(Pipeline.Workspace)/manifests/service.yaml
                    containers: |
                      myacr.azurecr.io/myapp:$(Build.BuildNumber)
                    imagePullSecrets: |
                      acr-secret

                # Method 3: Helm deploy
                - task: HelmDeploy@0
                  displayName: 'Helm upgrade'
                  inputs:
                    connectionType: 'Azure Resource Manager'
                    azureSubscription: 'my-azure-service-connection'
                    azureResourceGroup: 'myapp-rg'
                    kubernetesCluster: 'my-aks-cluster'
                    namespace: 'production'
                    command: 'upgrade'
                    chartType: 'FilePath'
                    chartPath: '$(Pipeline.Workspace)/charts/myapp'
                    releaseName: 'myapp'
                    overrideValues: |
                      image.tag=$(Build.BuildNumber)
                      replicaCount=3
                    install: true
                    waitForExecution: true
```

---

## Q85. How do you integrate SonarQube code quality analysis in an Azure DevOps pipeline?

**Answer:**

```yaml
variables:
  - group: sonarqube-credentials   # Contains SONAR_TOKEN

stages:
  - stage: Build
    jobs:
      - job: BuildAndAnalyze
        pool:
          vmImage: 'ubuntu-latest'
        steps:
          - checkout: self
            fetchDepth: 0    # Required for SonarQube branch analysis

          - task: SonarQubePrepare@6
            displayName: 'Prepare SonarQube analysis'
            inputs:
              SonarQube: 'sonarqube-service-connection'
              scannerMode: 'MSBuild'   # or 'CLI' for other project types
              projectKey: 'myapp'
              projectName: 'My Application'
              extraProperties: |
                sonar.exclusions=**/obj/**,**/*.dll
                sonar.coverage.exclusions=**Tests*.cs
                sonar.cs.opencover.reportsPaths=$(Agent.TempDirectory)/**/coverage.opencover.xml
                sonar.qualitygate.wait=true

          - task: DotNetCoreCLI@2
            inputs:
              command: 'build'
              projects: '**/*.csproj'

          - task: DotNetCoreCLI@2
            displayName: 'Run tests with coverage'
            inputs:
              command: 'test'
              projects: '**/*Tests.csproj'
              arguments: '--collect:"XPlat Code Coverage" -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover'

          - task: SonarQubeAnalyze@6
            displayName: 'Run SonarQube analysis'

          - task: SonarQubePublish@6
            displayName: 'Publish SonarQube results'
            inputs:
              pollingTimeoutSec: '300'

          # Fail pipeline if quality gate fails
          - task: sonarqube-buildbreaker@2
            displayName: 'Break build on Quality Gate failure'
            inputs:
              SonarQube: 'sonarqube-service-connection'
```

**SonarQube quality gate criteria (example):**
- Code coverage > 80%
- No new critical vulnerabilities
- Technical debt < 30 minutes
- Duplicated code < 3%

---

## Q86. How do you use runtime parameters in YAML pipelines?

**Answer:**

**Parameters** are evaluated at compile time (unlike variables which are runtime). They support rich types and validation.

```yaml
parameters:
  - name: environment
    displayName: 'Deployment environment'
    type: string
    default: dev
    values:           # Dropdown in the UI
      - dev
      - staging
      - production

  - name: imageTag
    displayName: 'Docker image tag to deploy'
    type: string
    default: 'latest'

  - name: runTests
    displayName: 'Run automated tests?'
    type: boolean
    default: true

  - name: nodeCount
    displayName: 'Number of AKS nodes'
    type: number
    default: 3

  - name: services
    displayName: 'Services to build'
    type: object
    default:
      - api
      - frontend
      - worker

trigger: none    # Manual only with parameters

jobs:
  - job: Build
    steps:
      - ${{ each service in parameters.services }}:
        - script: docker build -t $(registry)/${{ service }}:${{ parameters.imageTag }} ./${{ service }}
          displayName: 'Build ${{ service }}'

  - ${{ if eq(parameters.runTests, true) }}:
    - job: Test
      steps:
        - script: pytest tests/

  - job: Deploy
    steps:
      - script: |
          echo "Deploying to ${{ parameters.environment }}"
          echo "Image tag: ${{ parameters.imageTag }}"
          echo "Node count: ${{ parameters.nodeCount }}"
```

**Accessing parameters:**
```yaml
# Compile-time (template expression)
${{ parameters.environment }}

# If conditions
${{ if eq(parameters.environment, 'production') }}:

# Loop
${{ each service in parameters.services }}:
```

---

## Q87. How do you set up a multi-stage CI/CD pipeline for a microservices application?

**Answer:**

```yaml
# azure-pipelines.yml
trigger:
  branches:
    include: [main]

parameters:
  - name: services
    type: object
    default: [api, worker, frontend]

variables:
  - group: production-vars
  - name: registry
    value: myacr.azurecr.io
  - name: tag
    value: $(Build.BuildNumber)

stages:
  # ─── STAGE 1: Build all services in parallel ───
  - stage: Build
    displayName: 'Build & Push Images'
    jobs:
      - ${{ each service in parameters.services }}:
        - job: Build_${{ service }}
          displayName: 'Build ${{ service }}'
          pool:
            vmImage: ubuntu-latest
          steps:
            - checkout: self

            - task: Docker@2
              displayName: 'Build & push ${{ service }}'
              inputs:
                command: buildAndPush
                containerRegistry: 'acr-service-connection'
                repository: '${{ service }}'
                dockerfile: '${{ service }}/Dockerfile'
                tags: |
                  $(tag)
                  latest

  # ─── STAGE 2: Integration tests ───
  - stage: IntegrationTests
    displayName: 'Integration Tests'
    dependsOn: Build
    jobs:
      - job: IntegrationTest
        pool:
          vmImage: ubuntu-latest
        steps:
          - script: |
              docker-compose -f tests/integration/docker-compose.yml up -d
              sleep 10
              pytest tests/integration/ --junit-xml=results.xml
              docker-compose down
            displayName: 'Run integration tests'

          - task: PublishTestResults@2
            condition: always()
            inputs:
              testResultsFiles: 'results.xml'

  # ─── STAGE 3: Deploy to Dev ───
  - stage: DeployDev
    displayName: 'Deploy to Dev'
    dependsOn: IntegrationTests
    jobs:
      - deployment: Deploy
        environment: dev
        strategy:
          runOnce:
            deploy:
              steps:
                - ${{ each service in parameters.services }}:
                  - task: KubernetesManifest@1
                    displayName: 'Deploy ${{ service }}'
                    inputs:
                      action: deploy
                      kubernetesCluster: 'my-aks-cluster'
                      azureResourceGroup: 'myapp-rg'
                      azureSubscriptionConnection: 'azure-service-connection'
                      namespace: dev
                      manifests: k8s/${{ service }}/deployment.yaml
                      containers: $(registry)/${{ service }}:$(tag)

  # ─── STAGE 4: Deploy to Production (approval required) ───
  - stage: DeployProduction
    displayName: 'Deploy to Production'
    dependsOn: DeployDev
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: Deploy
        environment: production   # Configured with approval gates
        strategy:
          canary:
            increments: [25, 50, 100]
            deploy:
              steps:
                - script: echo "Deploying $(strategy.increment)% of traffic"
            postRouteTraffic:
              steps:
                - script: ./run-smoke-tests.sh
            on:
              failure:
                steps:
                  - script: ./rollback.sh
```

---

## Q88. How do you use the Azure CLI task in YAML pipelines?

**Answer:**

The **AzureCLI@2** task authenticates using a service connection and runs Azure CLI commands, supporting bash, PowerShell, and batch scripts.

```yaml
steps:
  # Run inline AZ CLI commands
  - task: AzureCLI@2
    displayName: 'Get AKS credentials'
    inputs:
      azureSubscription: 'my-service-connection'
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az aks get-credentials \
          --resource-group $(resourceGroup) \
          --name $(clusterName) \
          --overwrite-existing
        kubectl get nodes

  # Run a script file
  - task: AzureCLI@2
    displayName: 'Run deployment script'
    inputs:
      azureSubscription: 'my-service-connection'
      scriptType: 'bash'
      scriptLocation: 'scriptPath'
      scriptPath: 'scripts/deploy.sh'
      arguments: '$(environment) $(imageTag)'
      addSpnToEnvironment: true  # Exposes $servicePrincipalId, $servicePrincipalKey, $tenantId

  # Create Azure resources
  - task: AzureCLI@2
    displayName: 'Create container registry'
    inputs:
      azureSubscription: 'my-service-connection'
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        # Create if not exists
        az acr create \
          --resource-group $(resourceGroup) \
          --name $(registryName) \
          --sku Premium \
          --admin-enabled false

        # Get login server
        LOGIN_SERVER=$(az acr show --name $(registryName) --query loginServer -o tsv)
        echo "##vso[task.setvariable variable=registryLoginServer]$LOGIN_SERVER"
```

---

## Q89. How do you implement pipeline caching in Azure DevOps to speed up builds?

**Answer:**

Pipeline caching saves and restores files/directories between pipeline runs, reducing time spent downloading dependencies.

**Cache npm packages:**
```yaml
variables:
  npm_config_cache: $(Pipeline.Workspace)/.npm

steps:
  - task: Cache@2
    displayName: 'Cache npm packages'
    inputs:
      key: 'npm | "$(Agent.OS)" | package-lock.json'
      restoreKeys: |
        npm | "$(Agent.OS)"
        npm
      path: $(npm_config_cache)

  - script: npm ci   # Uses cache if available
    displayName: 'Install npm dependencies'
```

**Cache pip packages:**
```yaml
steps:
  - task: Cache@2
    displayName: 'Cache pip packages'
    inputs:
      key: 'pip | "$(Agent.OS)" | requirements.txt'
      restoreKeys: |
        pip | "$(Agent.OS)"
      path: $(Pipeline.Workspace)/.pip

  - script: pip install --cache-dir $(Pipeline.Workspace)/.pip -r requirements.txt
    displayName: 'Install Python dependencies'
```

**Cache Maven/Gradle:**
```yaml
steps:
  - task: Cache@2
    displayName: 'Cache Maven repository'
    inputs:
      key: 'maven | "$(Agent.OS)" | **/pom.xml'
      restoreKeys: |
        maven | "$(Agent.OS)"
      path: $(HOME)/.m2/repository
```

**Cache Docker layers:**
```yaml
steps:
  - task: Cache@2
    displayName: 'Cache Docker layers'
    inputs:
      key: 'docker | "$(Agent.OS)" | Dockerfile'
      path: $(Pipeline.Workspace)/docker-cache
      cacheHitVar: DOCKER_CACHE_HIT

  - script: |
      if [ "$(DOCKER_CACHE_HIT)" = "true" ]; then
        docker load -i $(Pipeline.Workspace)/docker-cache/image.tar
      fi
      docker build --cache-from myimage:latest -t myimage:$(tag) .
      mkdir -p $(Pipeline.Workspace)/docker-cache
      docker save myimage:latest -o $(Pipeline.Workspace)/docker-cache/image.tar
```

**Cache impact:** npm caching can reduce `npm install` from 90 seconds to 5 seconds. Maven caching can save several minutes of dependency download time.

---

## Q90. How do you implement secure secret injection in YAML pipelines?

**Answer:**

**Method 1: Variable groups linked to Key Vault:**
```yaml
variables:
  - group: keyvault-prod-secrets  # Group linked to Azure Key Vault
  # Secrets are pulled fresh from Key Vault at pipeline start
  # Available as $(secret-name)
```

**Method 2: Azure Key Vault task:**
```yaml
steps:
  - task: AzureKeyVault@2
    displayName: 'Get secrets from Key Vault'
    inputs:
      azureSubscription: 'my-service-connection'
      keyVaultName: 'my-keyvault'
      secretsFilter: 'db-password,api-key,jwt-secret'  # Specific secrets or '*' for all
      runAsPreJob: true  # Available to all jobs in stage

  - script: |
      echo "DB password length: ${#DB_PASSWORD}"
      # Never echo the actual secret value!
    env:
      DB_PASSWORD: $(db-password)   # Map secret to environment variable
```

**Method 3: Managed Identity / Federated credentials (no stored secrets):**
```yaml
steps:
  - task: AzureCLI@2
    inputs:
      azureSubscription: 'workload-identity-service-connection'  # Uses federated identity
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        # No credentials stored — uses OIDC token automatically
        SECRET=$(az keyvault secret show --vault-name my-kv --name db-password --query value -o tsv)
        echo "##vso[task.setvariable variable=DB_PASSWORD;issecret=true]$SECRET"
```

**Security best practices:**
```yaml
steps:
  - script: |
      # ✓ Good: use environment variable mapping
      ./myapp --db-password "$DB_PASSWORD"
    env:
      DB_PASSWORD: $(secret-db-password)  # Masked in logs

  - script: |
      # ✗ Bad: inline secret in command (appears in logs!)
      ./myapp --db-password $(secret-db-password)
```

---

## Q91. How do you implement parallel jobs with fan-out and fan-in patterns?

**Answer:**

**Fan-out:** One job spawns multiple parallel jobs.
**Fan-in:** Multiple jobs converge into a single downstream job.

```yaml
stages:
  - stage: Build
    jobs:
      - job: BuildApp
        steps:
          - script: dotnet build

  # ─── FAN-OUT: Multiple test types run in parallel ───
  - stage: Test
    dependsOn: Build
    jobs:
      - job: UnitTests
        displayName: 'Unit Tests'
        steps:
          - script: dotnet test --filter Category=Unit

      - job: IntegrationTests
        displayName: 'Integration Tests'
        steps:
          - script: dotnet test --filter Category=Integration

      - job: SecurityScan
        displayName: 'OWASP Security Scan'
        steps:
          - script: ./owasp-scan.sh

      - job: CodeQuality
        displayName: 'SonarQube Analysis'
        steps:
          - script: sonar-scanner

  # ─── FAN-IN: All test jobs must pass before deploy ───
  - stage: Deploy
    dependsOn:
      - Test
    condition: |
      and(
        succeeded('Test', 'UnitTests'),
        succeeded('Test', 'IntegrationTests'),
        succeeded('Test', 'SecurityScan'),
        succeeded('Test', 'CodeQuality')
      )
    jobs:
      - deployment: Deploy
        environment: staging
        strategy:
          runOnce:
            deploy:
              steps:
                - script: ./deploy.sh
```

**Cross-job dependencies (passing artifacts):**
```yaml
jobs:
  - job: GenerateReport
    steps:
      - script: generate-report.sh > report.json
      - publish: report.json
        artifact: reports

  - job: ConsumeReport
    dependsOn: GenerateReport
    steps:
      - download: current
        artifact: reports
      - script: cat $(Pipeline.Workspace)/reports/report.json
```

---

## Q92. How do you implement rollback in Azure DevOps pipelines?

**Answer:**

**Method 1: Helm rollback:**
```yaml
steps:
  - task: HelmDeploy@0
    displayName: 'Deploy new version'
    inputs:
      command: upgrade
      releaseName: myapp
      chartPath: ./charts/myapp
      overrideValues: 'image.tag=$(Build.BuildNumber)'
      waitForExecution: true

  - task: HelmDeploy@0
    displayName: 'Rollback on failure'
    condition: failed()
    inputs:
      command: rollback
      releaseName: myapp
      waitForExecution: true
```

**Method 2: Kubernetes deployment rollback:**
```yaml
- task: AzureCLI@2
  displayName: 'Deploy and verify'
  inputs:
    scriptType: bash
    inlineScript: |
      kubectl set image deployment/myapp myapp=$(registry)/myapp:$(tag) -n production
      
      # Wait for rollout to complete
      if ! kubectl rollout status deployment/myapp -n production --timeout=5m; then
        echo "Deployment failed, rolling back..."
        kubectl rollout undo deployment/myapp -n production
        echo "##vso[task.logissue type=error]Deployment failed and was rolled back"
        exit 1
      fi
      
      echo "Deployment successful"
```

**Method 3: Blue-Green slot swap rollback:**
```yaml
steps:
  - task: AzureAppServiceManage@0
    displayName: 'Swap to production'
    inputs:
      action: Swap Slots
      webAppName: myapp
      sourceSlot: staging
      swapWithProduction: true

  - script: ./verify-production.sh
    displayName: 'Verify production health'

  - task: AzureAppServiceManage@0
    displayName: 'Swap back on failure (rollback)'
    condition: failed()
    inputs:
      action: Swap Slots
      webAppName: myapp
      sourceSlot: production    # Swap back (staging becomes old prod again)
      swapWithProduction: false
      destinationSlot: staging
```

---

## Q93. How do you configure resource limits and timeouts in YAML pipelines?

**Answer:**

```yaml
jobs:
  - job: LongRunningJob
    displayName: 'Build & Test'
    timeoutInMinutes: 120          # Job cancels if exceeds 2 hours (default: 60)
    cancelTimeoutInMinutes: 5      # Grace period for cleanup on cancellation

    pool:
      vmImage: 'ubuntu-latest'

    steps:
      - script: ./run-tests.sh
        displayName: 'Run tests'
        timeoutInMinutes: 30       # Step-level timeout
        retryCountOnTaskFailure: 3 # Auto-retry up to 3 times on failure
        continueOnError: false     # Stop pipeline on failure

      - task: Docker@2
        displayName: 'Push image'
        timeoutInMinutes: 15
        retryCountOnTaskFailure: 2  # Retry on flaky network

  - job: Deployment
    timeoutInMinutes: 30
    cancelTimeoutInMinutes: 10   # Allow 10 min for graceful shutdown

# Stage timeout
stages:
  - stage: LongTest
    jobs:
      - job: TestWithTimeout
        timeoutInMinutes: 240   # 4 hours
```

**Self-hosted agent job timeouts:**
- Default: no timeout (runs indefinitely)
- Always set explicit timeouts on self-hosted agents for hung jobs

**Pipeline timeout:**
```yaml
# Top-level pipeline timeout
variables:
  system.debug: false

# No top-level timeout keyword in YAML — set at job level
```

---

## Q94. How do you validate YAML pipeline syntax before committing?

**Answer:**

**Method 1: Azure DevOps YAML validator in the UI:**
- Navigate to your pipeline → Edit
- Click the three dots (**...**) → **Validate**
- Shows syntax and structural errors immediately

**Method 2: Pipeline preview (dry run):**
- Click **Run** on the pipeline → **Run pipeline**
- Expand **Advanced options** → **Preview** to see the fully expanded YAML with template substitutions

**Method 3: Azure DevOps REST API:**
```bash
# POST to validate YAML
curl -X POST \
  "https://dev.azure.com/{org}/{project}/_apis/pipelines/{pipelineId}/preview?api-version=7.1-preview" \
  -H "Authorization: Basic $(echo -n :$PAT | base64)" \
  -H "Content-Type: application/json" \
  -d '{"previewRun": true}'
```

**Method 4: azure-pipelines-vscode extension:**
- VS Code extension: **Azure Pipelines** by Microsoft
- Provides IntelliSense, schema validation, and task documentation inline
- Validates syntax as you type

**Method 5: GitHub Actions — schema validation (yamllint + azure-pipelines schema):**
```bash
pip install yamllint
yamllint azure-pipelines.yml

# Download Azure Pipelines JSON schema
curl -o azure-pipelines-schema.json \
  https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/main/service-schema.json

# Validate with ajv-cli or similar
npx ajv validate -s azure-pipelines-schema.json -d azure-pipelines.yml
```

**Pre-commit hook for YAML validation:**
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/adrienverge/yamllint
    hooks:
      - id: yamllint
        files: azure-pipelines.*\.yml
        args: [--strict]
```

---

## Q95. How do you implement notifications in Azure DevOps YAML pipelines?

**Answer:**

**Method 1: Teams/Slack notification task:**
```yaml
steps:
  - script: ./deploy.sh
    displayName: 'Deploy application'

  - task: PowerShell@2
    displayName: 'Notify Teams on success'
    condition: succeeded()
    inputs:
      targetType: 'inline'
      script: |
        $body = @{
          "@type" = "MessageCard"
          "@context" = "http://schema.org/extensions"
          "summary" = "Deployment Successful"
          "themeColor" = "00FF00"
          "title" = "✅ Deployment to $(environment) succeeded"
          "text" = "Build: $(Build.BuildNumber) deployed by $(Build.RequestedFor)"
        } | ConvertTo-Json
        
        Invoke-RestMethod -Uri "$(TEAMS_WEBHOOK_URL)" -Method POST -Body $body -ContentType "application/json"

  - task: PowerShell@2
    displayName: 'Notify Teams on failure'
    condition: failed()
    inputs:
      targetType: 'inline'
      script: |
        $body = @{
          "@type" = "MessageCard"
          "themeColor" = "FF0000"
          "title" = "❌ Deployment to $(environment) FAILED"
          "text" = "Build $(Build.BuildNumber) failed. [View logs]($(System.CollectionUri)$(System.TeamProject)/_build/results?buildId=$(Build.BuildId))"
        } | ConvertTo-Json
        Invoke-RestMethod -Uri "$(TEAMS_WEBHOOK_URL)" -Method POST -Body $body -ContentType "application/json"
```

**Method 2: Azure DevOps built-in notifications (configured separately):**
- Project Settings → Notifications → New subscription
- Configure email/Teams notifications for pipeline events

**Method 3: Azure Communication Services for email:**
```yaml
- task: AzureCLI@2
  displayName: 'Send deployment email'
  condition: always()
  inputs:
    scriptType: bash
    inlineScript: |
      STATUS="${{ job.status }}"
      az communication email send \
        --connection-string "$(ACS_CONNECTION_STRING)" \
        --sender "noreply@mycompany.com" \
        --to "devops-team@mycompany.com" \
        --subject "Deployment $STATUS: $(Build.BuildNumber)" \
        --text "Deployment to $(environment) $STATUS at $(date)"
```

---

## Q96. How do you implement GitOps with Azure DevOps and Argo CD?

**Answer:**

**GitOps** is a deployment practice where Git is the single source of truth for declarative infrastructure and application state. Changes to Git trigger automatic synchronization to the cluster.

**Architecture:**
```
Developer pushes code
        ↓
CI Pipeline (Azure DevOps)
  - Build Docker image
  - Push to ACR
  - Update image tag in Helm values (via PR or direct commit)
        ↓
Git repo (manifests repo) updated
        ↓
Argo CD detects drift between Git and cluster
        ↓
Argo CD syncs cluster to match Git state
```

**Pipeline that updates the GitOps repo:**
```yaml
steps:
  - task: Docker@2
    displayName: 'Build and push image'
    inputs:
      command: buildAndPush
      containerRegistry: 'acr-connection'
      repository: myapp
      tags: $(Build.BuildNumber)

  - script: |
      git clone https://$(GITOPS_PAT)@dev.azure.com/myorg/myproject/_git/gitops-manifests
      cd gitops-manifests

      # Update image tag in Helm values
      sed -i "s|tag: .*|tag: $(Build.BuildNumber)|g" charts/myapp/values.yaml

      git config user.email "pipeline@mycompany.com"
      git config user.name "Azure Pipeline"
      git add charts/myapp/values.yaml
      git commit -m "chore: update myapp image to $(Build.BuildNumber) [skip ci]"
      git push
    displayName: 'Update GitOps manifest'
```

**Argo CD Application:**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp-production
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://dev.azure.com/myorg/myproject/_git/gitops-manifests
    targetRevision: main
    path: charts/myapp
    helm:
      valueFiles:
        - values-production.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

---

## Q97. How do you use deployment strategies in Azure DevOps YAML pipelines?

**Answer:**

Azure DevOps YAML supports three deployment strategies for `deployment` jobs:

**1. runOnce (default):**
```yaml
strategy:
  runOnce:
    preDeploy:
      steps:
        - script: echo "Pre-deploy checks"
    deploy:
      steps:
        - script: ./deploy.sh
    routeTraffic:
      steps:
        - script: ./route-traffic.sh
    postRouteTraffic:
      steps:
        - script: ./smoke-tests.sh
    on:
      failure:
        steps:
          - script: ./rollback.sh
      success:
        steps:
          - script: ./notify-success.sh
```

**2. rolling (deploy to subsets of VMs):**
```yaml
strategy:
  rolling:
    maxParallel: 2     # Deploy to 2 VMs at a time
    preDeploy:
      steps:
        - script: echo "Pre-deploy on $(Strategy.CycleName)"
    deploy:
      steps:
        - script: |
            echo "Current cycle: $(Strategy.CycleName)"   # e.g., "Cycle 1"
            echo "Current limit: $(Strategy.CurrentTarget)"
            ./deploy-to-vm.sh
    on:
      failure:
        steps:
          - script: ./rollback-vm.sh
```

**3. canary (gradual traffic shifting):**
```yaml
strategy:
  canary:
    increments: [10, 50, 100]   # 10% → 50% → 100%
    preDeploy:
      steps:
        - script: echo "Starting canary at $(strategy.increment)%"
    deploy:
      steps:
        - script: ./deploy-canary.sh --weight $(strategy.increment)
    routeTraffic:
      steps:
        - script: ./update-traffic-weight.sh $(strategy.increment)
    postRouteTraffic:
      steps:
        - script: ./run-canary-tests.sh
        - task: AzureMonitor@1
          inputs:
            # Check error rate < 1% before proceeding
    on:
      failure:
        steps:
          - script: ./remove-canary.sh
```

---

## Q98. How do you use extend templates for security and compliance in YAML pipelines?

**Answer:**

**Extend templates** enforce that all pipelines in an organization use approved pipeline structures. They're mandatory (configured via pipeline settings) — teams cannot bypass them.

**Use cases:**
- Require security scanning in all pipelines
- Enforce approved agent pools
- Block unapproved tasks
- Standardize deployment gates

**Base template — `templates/secure-pipeline.yml`:**
```yaml
parameters:
  - name: stages
    type: stageList
    default: []

extends:
  template: /templates/base-template.yml
  parameters:
    stages: ${{ parameters.stages }}
```

**Base template implementation:**
```yaml
# templates/base-template.yml
parameters:
  - name: stages
    type: stageList

resources:
  repositories:
    - repository: templates
      type: git
      name: MyOrg/pipeline-templates
      ref: refs/heads/main

stages:
  # Security scan always runs first
  - stage: SecurityCheck
    displayName: 'Security Compliance Check'
    jobs:
      - job: Credentials
        steps:
          - task: CredScan@3        # Scan for credentials in code
          - task: Checkov@1         # IaC security scan
          - task: trivy@1           # Container vulnerability scan

  # Allow pipeline's own stages
  - ${{ each stage in parameters.stages }}:
    - ${{ stage }}

  # Compliance notification always runs last
  - stage: ComplianceReport
    jobs:
      - job: Report
        steps:
          - script: ./generate-compliance-report.sh
```

**Pipeline using extends (team's azure-pipelines.yml):**
```yaml
extends:
  template: secure-pipeline.yml@templates
  parameters:
    stages:
      - stage: Build
        jobs:
          - job: BuildJob
            steps:
              - script: dotnet build
      - stage: Deploy
        jobs:
          - deployment: Deploy
            environment: production
```

**Organization policy:** In Azure DevOps, navigate to **Organization Settings → Pipelines → Settings** and require all pipelines to extend a specific template — blocking any pipeline that doesn't.

---

## Q99. How do you implement self-service pipelines and pipeline as code best practices?

**Answer:**

**Pipeline as Code best practices:**

**1. Repository structure:**
```
.azuredevops/
├── azure-pipelines.yml          # Main pipeline
├── pr-pipeline.yml              # PR validation pipeline
└── templates/
    ├── build.yml                # Build steps template
    ├── test.yml                 # Test steps template
    ├── deploy.yml               # Deployment template
    └── security-scan.yml        # Security scanning template

.github/                         # If also using GitHub
```

**2. Semantic versioning with GitVersion:**
```yaml
steps:
  - task: gitversion/setup@0
    inputs:
      versionSpec: '5.x'

  - task: gitversion/execute@0
    name: GitVersion

  - script: |
      echo "Version: $(GitVersion.SemVer)"
      echo "Major: $(GitVersion.Major)"
      echo "##vso[build.updatebuildnumber]$(GitVersion.SemVer)"
```

**3. Environment promotion pattern:**
```yaml
# Promote the same image across environments — never rebuild
variables:
  image: $(registry)/myapp:$(sourceBuildNumber)  # Tag from build pipeline

stages:
  - stage: DeployDev
    jobs:
      - deployment: Deploy
        steps:
          - script: helm upgrade myapp ./charts/myapp --set image.tag=$(image)

  - stage: PromoteToStaging
    jobs:
      - script: |
          # Retag image (don't rebuild!)
          az acr import --name myacr --source myacr.azurecr.io/myapp:$(sourceBuildNumber) --image myapp:staging
```

**4. Pipeline linting in CI:**
```yaml
# Self-validating pipeline
steps:
  - script: |
      # Validate all YAML pipeline files
      find . -name 'azure-pipelines*.yml' -exec yamllint {} \;
    displayName: 'Lint pipeline YAML files'
```

---

## Q100. What are the differences between Classic and YAML pipelines and when should you use each?

**Answer:**

| Aspect | Classic Pipelines | YAML Pipelines |
|--------|------------------|----------------|
| **Configuration** | GUI-based (click-ops) | Code (azure-pipelines.yml) |
| **Version control** | Pipeline config not in repo | Pipeline committed alongside code |
| **Portability** | Tied to Azure DevOps UI | Portable, reproducible |
| **Code review** | Cannot PR-review pipeline changes | Pipeline changes go through PR process |
| **Auditability** | Limited history | Full git history of every change |
| **Templating** | Limited reusability | Rich template support |
| **Parameters** | Basic | Strongly-typed with validation |
| **Multi-stage** | Yes (Release pipelines) | Yes (stages in YAML) |
| **Deployment strategies** | GUI-configured | canary, rolling, runOnce |
| **Extend templates** | Not supported | Enforces organization security |
| **Ease of setup** | Easier for beginners | Steeper initial learning curve |
| **YAML deployment groups** | Not supported in YAML | Use environments instead |
| **Best for** | Legacy, quick prototypes | All new pipelines |

**Migration from Classic to YAML:**
1. Use **Export to YAML** button in the Classic editor to get a starting YAML
2. Review and clean up generated YAML (it's verbose)
3. Move into repository and create a new YAML pipeline pointing to the file
4. Test thoroughly in a non-production environment
5. Disable the Classic pipeline once YAML is validated

**Recommendation:** All new pipelines should use YAML. Migrate Classic pipelines incrementally, prioritizing those with active development. Classic pipelines that are rarely changed can stay Classic.

---

## Summary Reference Table

| Category | Key Topics Covered |
|----------|-------------------|
| **Azure DevOps (Q1-25)** | Services, CI/CD, Service Connections, Branch Policies, Secrets, Agents, Environments, Artifacts, Org Structure, APIs, REST, Git Flow, Extensions, Approvals, Test Plans, Auditing |
| **Kubernetes (Q26-50)** | Architecture, Workloads, Services, Ingress, ConfigMaps/Secrets, HPA, Namespaces, PV/PVC, Probes, RBAC, Rolling Updates, DaemonSets, Taints/Affinity, NetworkPolicy, Helm, Resources, etcd, TLS, PDB, Monitoring, Init/Sidecar, CRDs, Cluster Autoscaler, Zero-Downtime, Operators |
| **Terraform (Q51-75)** | State, Modules, Commands, Data Sources, Variables, Locals, Workspaces, Provisioners, Team Management, Import, Outputs, Drift, Terragrunt, AKS Config, for_each/count, depends_on, Security Scanning, tfvars, Lifecycle, fmt/validate, Provider Versions, CI/CD, Registry, Testing |
| **YAML Pipelines (Q76-100)** | Structure, Triggers, Variables, Templates, Artifacts, Matrix Builds, Conditions, Docker, AKS Deploy, SonarQube, Parameters, Microservices CI/CD, Azure CLI, Caching, Secrets, Fan-out/Fan-in, Rollback, Timeouts, Validation, Notifications, GitOps, Deployment Strategies, Extend Templates, Pipeline as Code, Classic vs YAML |

---

*100 Real-Time Interview Questions — Azure DevOps | Kubernetes | Terraform | YAML Pipelines*
*Prepared April 2026*
