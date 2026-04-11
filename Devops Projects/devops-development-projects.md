# DevOps Development Projects (Azure DevOps)

Thirty hands-on development projects focused on **Azure DevOps** (Repos, Pipelines, Boards, Artifacts, Test Plans) and delivery to **Microsoft Azure**, using YAML pipelines, service connections, and Azure-native tooling.

---

## 1. CI/CD for a Microservices Monorepo in Azure Repos

**Description**  
Design Azure Pipelines with path filters, template reuse, and parallel jobs so each service in one Azure Repo builds, tests, and deploys independently with shared governance.

**Skills**  
Azure Pipelines YAML, `paths` triggers, pipeline templates, Azure Repos branching policies, Azure Artifacts, variable groups, Azure Key Vault task integration.

**Roles**  
Azure DevOps Engineer, Platform Engineer, Release Manager (with developers for test contracts).

**Responsibilities**  
- Define branch policies, required reviewers, and build validation pipelines in Azure Repos.  
- Implement multi-stage YAML with template `extends` for shared build/deploy patterns.  
- Use path filters and `dependsOn` so only changed microservices run in CI.  
- Publish versioned packages or container images to Azure Artifacts / Azure Container Registry.  
- Wire deployments through **Environments** with approvals, checks, and deployment gates.  
- Map secrets from Azure Key Vault into pipelines via variable groups or `AzureKeyVault@2`.  
- Document pipeline parameters, troubleshooting, and ownership in Azure Wiki.  
- Track **Pipelines Analytics** (duration, pass rate) and reduce flaky stages.

---

## 2. Infrastructure as Code with Bicep / ARM via Azure Pipelines

**Description**  
Provision Azure networking, App Service, SQL, and load balancing using Bicep or ARM, deployed through Azure Pipelines with per-environment parameter files and least-privilege service principals.

**Skills**  
Bicep or ARM templates, Azure Resource Manager service connections, `AzureResourceManagerTemplateDeployment@3`, parameter files, Azure CLI (`az deployment`), pipeline environments.

**Roles**  
Azure DevOps Engineer, Azure Cloud Architect, Security reviewer.

**Responsibilities**  
- Store IaC in Azure Repos with PR reviews and optional what-if validation tasks.  
- Use workload identity federation or scoped service connections for subscription access.  
- Model dev/stage/prod with separate resource groups and pipeline parameters.  
- Run `what-if` or validation stage before production `subscription`/`resourceGroup` scope deploys.  
- Output connection strings and endpoints into Key Vault—not committed plaintext.  
- Tag resources for cost allocation; align naming with Azure governance standards.  
- Implement rollback or redeploy procedures documented in runbooks.  
- Integrate successful deploys with Azure Boards work item linking.

---

## 3. AKS Baseline Delivered Through Azure Pipelines

**Description**  
Automate cluster add-ons (ingress, cert-manager, monitoring agents) and namespace baselines using Helm or Kustomize invoked from Azure Pipelines targeting AKS.

**Skills**  
AKS, `Kubernetes@1` / `HelmDeploy@0` tasks, Azure CLI `az aks`, service connections (Kubernetes), Azure Monitor container insights, Azure Key Vault for secrets.

**Roles**  
Platform Engineer, Azure DevOps Engineer, SRE.

**Responsibilities**  
- Create Kubernetes service connections with kubeconfig from AKS and restrict RBAC.  
- Pipeline stages: validate manifests, deploy to non-prod, then prod with approvals.  
- Store Helm values per environment in Azure Repos or secure variable groups.  
- Enable Azure Monitor for containers and link dashboards to release health.  
- Use Azure Pipelines **Environments** with Kubernetes resource for traceability.  
- Document cluster upgrade alignment with AKS release notes and pipeline freeze windows.  
- Automate `kubectl` / Helm upgrades with rollback steps in YAML.  
- Validate baseline with a sample workload deployed from the same pipeline family.

---

## 4. Git-Based Release Flow with Azure Repos and Multi-Stage Pipelines

**Description**  
Implement trunk-based or GitFlow promotion using Azure Repos, protected branches, and multi-stage YAML that promotes builds across dev → stage → prod without external GitOps servers.

**Skills**  
Azure Repos branch policies, YAML stages and `deployment` jobs, pipeline resources (`pipelines:` / `resources.repositories`), commit tagging, Azure Environments.

**Roles**  
Azure DevOps Engineer, Application Lead, Release Manager.

**Responsibilities**  
- Map branches to environments and restrict who can merge to release branches.  
- Use pipeline resource triggers to chain build → release pipelines.  
- Configure environment approvals and optional branch filters for production.  
- Implement semantic or calendar versioning with `git tag` tasks in pipeline.  
- Document rollback by redeploying a previous pipeline run or artifact version.  
- Link releases to Azure Boards work items via integrated mentions or tasks.  
- Store infrastructure and app manifests in the same project or multi-repo with `checkout`.  
- Track deployment frequency and lead time using Azure DevOps reporting.

---

## 5. Container Build, Scan, and Push to ACR from Azure Pipelines

**Description**  
Standardize `Docker@2` builds, integrate vulnerability scanning (e.g., Defender for Cloud, Trivy, or Microsoft-hosted tasks), and push only passing images to Azure Container Registry.

**Skills**  
`Docker@2`, Azure Container Registry service connection, ACR tasks (optional), Microsoft Defender for DevOps, pipeline templates, Azure Artifacts (optional base images).

**Roles**  
Azure DevOps Engineer, Security Engineer, Developers consuming base images.

**Responsibilities**  
- Use ACR service connections and avoid embedding registry passwords in YAML.  
- Enforce multi-stage Dockerfiles and non-root users via review checklist.  
- Add scanning stage that fails on critical CVEs per org policy.  
- Tag images with build ID and git commit for traceability to Azure Pipelines runs.  
- Configure ACR retention policies and geo-replication if required.  
- Publish digest or SBOM as pipeline artifacts for audit.  
- Document how developers trigger manual runs and interpret scan failures.  
- Optimize layer caching using Azure Pipelines cache tasks where appropriate.

---

## 6. Observability: Azure Monitor & Application Insights in Pipelines

**Description**  
Instrument releases and health checks using Application Insights, Log Analytics, and Azure Monitor metrics, with gates or manual verification steps in Azure Pipelines.

**Skills**  
Application Insights, Log Analytics queries, Azure Monitor metrics, `AzureMonitor@1` (optional gates), ARM/Bicep for diagnostics settings, release annotations.

**Roles**  
SRE, Azure DevOps Engineer, Developers (instrumentation).

**Responsibilities**  
- Provision App Insights and workspace-linked resources via IaC pipelines.  
- Add deployment annotations or custom events from pipeline scripts post-deploy.  
- Define KQL queries for error rate and latency used in release checks.  
- Configure alert rules and action groups; document links in Azure Wiki.  
- Integrate workbook templates as living dashboards for each service.  
- Use variable groups to hold App Insights API keys securely (or Key Vault).  
- Train teams on correlating failed releases with `requests` / `dependencies` telemetry.  
- Review cardinality and sampling to control cost.

---

## 7. Secrets & Identity: Key Vault, Managed Identity, and Service Connections

**Description**  
Centralize pipeline and app secrets using Azure Key Vault, workload identity federation for Azure Pipelines, and scoped ARM/Kubernetes service connections.

**Skills**  
Azure Key Vault, workload identity federation (OIDC) for Azure Pipelines, service connections, managed identities, `AzureKeyVault@2`, library variable groups (secrets).

**Roles**  
Security Engineer, Azure DevOps Administrator, Platform Engineer.

**Responsibilities**  
- Replace long-lived secrets with federated credentials where supported.  
- Classify variable groups vs Key Vault references per sensitivity.  
- Audit **Project Settings → Service connections** access quarterly.  
- Automate rotation notifications using pipeline schedules and runbooks.  
- Document break-glass access and pipeline emergency disable procedures.  
- Ensure least privilege on service principals used by Azure Pipelines.  
- Block plain secrets in YAML via branch policies and PR extensions (e.g., secret scanning).  
- Align Key Vault access policies / RBAC with pipeline agent and runtime identities.

---

## 8. Reusable Azure Pipelines Template Library

**Description**  
Publish a project or repository of YAML templates (`template:` / `extends`) for build, scan, deploy, and compliance stages consumed by many teams in the same Azure DevOps organization.

**Skills**  
YAML schema for Azure Pipelines, template parameters, `extends`, repository resource templates, versioning via tags or branches, Azure Artifacts (optional).

**Roles**  
Platform Engineer, Azure DevOps Engineer.

**Responsibilities**  
- Design stable template interfaces (parameters with defaults and types).  
- Version templates with Git tags; document breaking changes in Azure Wiki.  
- Provide example consumer pipelines in a sample repo.  
- Enforce mandatory stages (e.g., security scan) via required template usage.  
- Test template changes in a dogfood project before org-wide rollout.  
- Use `runtime` parameters where teams need flexibility at queue time.  
- Document how to override agent pool (Microsoft-hosted vs self-hosted scale set).  
- Collect feedback via Azure Boards features linked to template repo.

---

## 9. Azure Functions / App Service Deploy Pipelines

**Description**  
Build CI/CD for .NET, Node, or Python apps to Azure Functions or Web Apps using `AzureWebApp@1`, deployment slots, and slot swap with pre-swap validation.

**Skills**  
`AzureWebApp@1`, `AzureFunctionApp@1`, deployment slots, App Service configuration, Azure Pipelines environments, Azure App Configuration (optional).

**Roles**  
Azure DevOps Engineer, Application Developer.

**Responsibilities**  
- Configure Azure subscription service connection scoped to resource group.  
- Implement build → deploy to staging slot → smoke tests → swap to production.  
- Externalize app settings; inject secrets from Key Vault references in App Service.  
- Use deployment center patterns or full YAML for repeatable ownership.  
- Link work items from commits and PRs using `#AB` syntax.  
- Add rollback procedure (swap back) in runbook and pipeline comments.  
- Monitor slot warm-up and Application Insights after swap.  
- Document which branch maps to which slot and environment.

---

## 10. Self-Hosted Agent Pools and Azure Virtual Machine Scale Sets

**Description**  
Stand up scalable self-hosted agents using Azure VMSS agent pools (or classic agent VMs) for specialized workloads, compliance zones, or heavy builds.

**Skills**  
Azure Pipelines agent pools, VMSS agents, Azure VMs, networking to Azure DevOps, agent capabilities, PAT/credentials for agent registration, image customization.

**Roles**  
Azure DevOps Administrator, Infrastructure Engineer.

**Responsibilities**  
- Design pool naming and map teams to pools via YAML `pool` declarations.  
- Harden agent images; patch regularly and rebuild via Image Builder pipelines.  
- Isolate production-deploy agents from build-only agents.  
- Configure autoscaling rules for VMSS based on queue depth.  
- Troubleshoot agent connectivity (firewall, TLS) to dev.azure.com or Azure DevOps Server.  
- Document installed software versions and update cadence in Wiki.  
- Monitor disk space and stale workspaces on long-lived agents.  
- Rotate org/collection PATs or managed identities used for registration per policy.

---

## 11. Internal Developer Portal Starter with Azure DevOps Backing APIs

**Description**  
Expose self-service flows (request variable group, queue pipeline, create repo from template) using Azure DevOps REST APIs, service hooks, and documented PowerShell/Azure CLI scripts.

**Skills**  
Azure DevOps REST API, PAT/OAuth apps, PowerShell `Invoke-RestMethod`, `az devops` CLI, JSON payloads, project permissions.

**Roles**  
Platform Engineer, Azure DevOps Engineer.

**Responsibilities**  
- Register applications or use PATs with minimum scopes for automation only.  
- Script repo creation from **Repo templates** and set default branch policies.  
- Automate variable group and environment creation with naming standards.  
- Publish scripts in Azure Repos with pipeline CI to validate syntax.  
- Add audit logging for who invoked which automation.  
- Document rate limits and idempotency for operators.  
- Integrate optional Power Apps / portal UI calling Azure DevOps APIs.  
- Review permissions quarterly for automation identities.

---

## 12. Policy & Compliance: Branch Policies, Required Templates, and Defender for DevOps

**Description**  
Enforce org standards using Azure Repos policies, optional required template enforcement, and Microsoft Defender for DevOps findings integrated into developer workflow.

**Skills**  
Branch policies, build validation, required reviewers, comment requirements, Defender for DevOps, IaC scanning in PRs, Azure Boards traceability.

**Roles**  
Security Engineer, Azure DevOps Administrator, Compliance liaison.

**Responsibilities**  
- Configure minimum reviewer count and optional path-based reviewers.  
- Require successful YAML pipeline or specific policy pipeline before merge.  
- Enable secret scanning and dependency alerts where licensed.  
- Document exceptions process with Azure Boards work items and expiry.  
- Integrate PR comments from external scanners via service hooks or extensions.  
- Train teams on resolving policy violations without bypassing governance.  
- Report policy bypass rates and justifications to leadership.  
- Align repository settings with org-level **Azure DevOps → Policies** where applicable.

---

## 13. Disaster Recovery for Pipeline Definitions and Azure DevOps Data

**Description**  
Backup and restore strategy for YAML sources in Git plus export of critical Azure DevOps configuration (service connections metadata, permissions model) and runbook execution.

**Skills**  
Azure Repos (Git is source of truth), `az devops` export patterns, Azure DevOps Server backup concepts (if on-prem), documentation, Bicep for Azure resources only.

**Roles**  
Azure DevOps Administrator, SRE, Security.

**Responsibilities**  
- Ensure all pipelines live in Git; eliminate “orphan” classic pipelines over time.  
- Document manual steps to recreate service connections and environments after org loss.  
- Store runbooks in Azure Wiki with quarterly drill dates.  
- Practice restoring a project area or repo from deleted-item recovery window.  
- Align with Microsoft responsibility model for SaaS data retention.  
- Export boards process templates and work item types if heavily customized.  
- Test cross-region failover assumptions for Azure DevOps service availability.  
- Update DR docs when pipeline or identity model changes.

---

## 14. FinOps Dashboards Using Azure Cost Management + Pipeline Tags

**Description**  
Use consistent pipeline-set tags on Azure resources and aggregate spend in Cost Management; add pipeline gates that warn when budgets are exceeded.

**Skills**  
Azure Cost Management + Billing, tags via Bicep/ARM, Azure CLI in pipelines, `AzureCLI@2`, budget alerts, Power BI or Log Analytics export (optional).

**Roles**  
FinOps analyst, Azure DevOps Engineer, Engineering manager.

**Responsibilities**  
- Enforce mandatory tags through IaC templates deployed from Azure Pipelines.  
- Add `application`, `environment`, `costcenter` from pipeline parameters.  
- Schedule monthly cost review pipeline that emails CSV or posts to Teams via webhook.  
- Document tag ownership in Azure Wiki.  
- Create budgets per subscription or resource group aligned to teams.  
- Link overspend investigations back to Azure Boards work items.  
- Avoid running expensive agent jobs unnecessarily (caching, path triggers).  
- Report savings from rightsizing triggered by cost anomaly alerts.

---

## 15. AKS Ingress, TLS, and Helm Releases from Azure Pipelines

**Description**  
Manage NGINX/App Routing ingress, cert-manager, and Helm releases to AKS exclusively through Azure Pipelines with environment promotion.

**Skills**  
AKS HTTP application routing or NGINX Helm chart, cert-manager, `HelmDeploy@0`, `Kubernetes@1`, DNS in Azure DNS, Key Vault for TLS (optional CSI driver).

**Roles**  
Platform Engineer, Azure DevOps Engineer.

**Responsibilities**  
- Store chart versions and values in Git; pin versions in YAML.  
- Use separate service connections per cluster/environment.  
- Run `helm lint` / `kubectl diff` (if available) in CI before deploy stage.  
- Configure production approvals on Kubernetes **Environment** resources.  
- Document how developers request new hostnames and certificates.  
- Monitor cert expiry via Azure Monitor alerts.  
- Roll back Helm release via pipeline parameter or documented manual `helm rollback`.  
- Keep AKS upgrade cadence coordinated with ingress chart compatibility.

---

## 16. Azure Artifacts: NuGet, npm, and Universal Packages in Builds

**Description**  
Standardize upstream feeds, `@local` views, and pipeline authentication to Azure Artifacts for internal libraries consumed across repos.

**Skills**  
Azure Artifacts feeds, `NuGetCommand@2`, `npm authenticate`, universal packages, `.npmrc` / `nuget.config` in repo, pipeline identity access.

**Roles**  
Build Engineer, Azure DevOps Engineer, Developers.

**Responsibilities**  
- Configure feed permissions for project vs organization scope.  
- Use `pipelines` identity or explicit PAT scopes in documented developer setup.  
- Promote packages through views (e.g., `@prerelease` → `@release`).  
- Version packages aligned with Azure Pipelines build number.  
- Document migration from external feeds to Azure Artifacts.  
- Clean up old versions per retention policy.  
- Integrate vulnerability scanning for dependencies in CI.  
- Link package publishing stages to Azure Boards releases or tags.

---

## 17. Teams / Slack Notifications for Azure Pipelines

**Description**  
Configure Microsoft Teams or Slack subscriptions to pipeline events, failed stages, and approval requests using built-in integrations or service hooks.

**Skills**  
Azure DevOps service hooks, Teams connector, Slack incoming webhooks, YAML `notifications` (where applicable), environment approval notifications.

**Roles**  
Azure DevOps Engineer, Collaboration admin.

**Responsibilities**  
- Map channels per project or critical pipeline.  
- Reduce noise by filtering to failed production stages only.  
- Document how approvers act on pending **Environments** from mobile.  
- Test webhook secret rotation procedures.  
- Ensure notifications do not leak secrets in payload customization.  
- Add links back to pipeline run and logs for triage.  
- Review subscription sprawl quarterly.  
- Align with incident comms playbooks for major outages.

---

## 18. Load Testing with Azure Load Testing in Release Pipelines

**Description**  
Integrate Azure Load Testing (or JMeter published as artifact) as a stage after deploy to staging, with pass/fail criteria gating promotion.

**Skills**  
Azure Load Testing, JMeter (optional), Azure Pipelines stages, Application Insights for server-side metrics, parameterization via variable groups.

**Roles**  
Performance engineer, Azure DevOps Engineer, QA.

**Responsibilities**  
- Store test definitions in Azure Repos and version with app.  
- Inject staging URLs and keys from Key Vault at runtime.  
- Define SLAs/thresholds aligned with product owners.  
- Fail pipeline on regression; attach report as artifact.  
- Schedule nightly runs via scheduled pipelines.  
- Document data setup for load env (sanitized).  
- Coordinate agent location and VNet injection if internal endpoints.  
- Track trends in Azure DevOps test results or wiki.

---

## 19. Feature Flags with Azure App Configuration in CD

**Description**  
Deploy configuration and feature flags via Azure App Configuration and reference keys from App Service/Functions pipelines with safe rollout practices.

**Skills**  
Azure App Configuration, `AzureAppConfigurationExport@10` (if used), ARM/Bicep, App Service settings, pipeline parameters for flag snapshots.

**Roles**  
Azure DevOps Engineer, Backend lead, Product.

**Responsibilities**  
- Separate flag changes from code deploy when possible using dedicated pipeline or task.  
- Document kill-switch procedure in runbooks.  
- Use labels for environment-specific values.  
- Integrate with Application Insights for operational flags (optional).  
- Restrict who can run production configuration pipeline via approvals.  
- Audit flag history through App Configuration revision logs.  
- Train teams on avoiding long-lived stale flags.  
- Link flag rollout tasks to Azure Boards items.

---

## 20. Database Schema Migrations with Azure SQL from Pipelines

**Description**  
Run Flyway, SqlPackage, or DACPAC deploy tasks against Azure SQL in controlled stages with backups and environment checks.

**Skills**  
Azure SQL, `SqlAzureDacpacDeployment@1`, Flyway CLI in pipeline, Key Vault for connection strings, Azure Pipelines environments, pre-deploy automation.

**Roles**  
DBA, Azure DevOps Engineer, Backend developer.

**Responsibilities**  
- Store migration scripts in Azure Repos with ordered naming convention.  
- Run migrations against ephemeral DB in CI for validation.  
- Require backup or point-in-time restore capability before prod migration stage.  
- Use separate service connections or firewall rules for pipeline agents to SQL.  
- Document backward-compatible deploy order with app releases.  
- Gate production with manual validation and approvals.  
- Capture migration logs as pipeline artifacts.  
- Post-deploy run smoke queries from `AzureCLI@2` or sqlcmd task.

---

## 21. Azure Front Door / CDN / Application Gateway Config as Pipeline

**Description**  
Deploy and update Azure Front Door, CDN, or Application Gateway rules using Bicep/ARM from Azure Pipelines with staged rollout.

**Skills**  
Bicep for Front Door / App Gateway, ARM deployments, Azure Pipelines, WAF policies, custom domains, Key Vault for certificates, DNS automation.

**Roles**  
Azure DevOps Engineer, Network/security engineer.

**Responsibilities**  
- Model dev/stage/prod profiles with parameter files.  
- Run what-if before production WAF or routing changes.  
- Automate certificate renewal integration points (Key Vault).  
- Document cache purge steps post-release if applicable.  
- Link routing changes to app release pipeline dependencies.  
- Test health probes from pipeline-deployed configuration.  
- Roll back by redeploying known-good template artifact.  
- Alert on configuration drift via scheduled validation pipeline.

---

## 22. Classic Pipeline to YAML Migration Project

**Description**  
Convert classic build/release definitions to YAML in Azure Repos with feature parity, modern tasks, and retirement of classic editors.

**Skills**  
Classic pipeline analysis, YAML conversion, task equivalence mapping, service connections migration, retention rules, branch policy updates.

**Roles**  
Azure DevOps Engineer, Build owner per application.

**Responsibilities**  
- Inventory classic definitions and triggers per team.  
- Generate YAML using **View YAML** or manual rewrite with improvements.  
- Recreate agent demands, variables, and secret mappings.  
- Parallel-run YAML vs classic until sign-off.  
- Update branch policies to point to new YAML pipelines.  
- Archive classic definitions after cutover.  
- Document differences (e.g., UI-only features replaced by templates).  
- Train developers on editing YAML vs classic UI.

---

## 23. API Management (APIM) Deployment via Azure Pipelines

**Description**  
Automate APIM instance, APIs, policies, and backends using Bicep/ARM and optional GitOps-style extraction from APIM developer portal artifacts.

**Skills**  
Azure API Management, ARM/Bicep, `AzureResourceManagerTemplateDeployment@3`, policy XML in Git, Azure Pipelines environments.

**Roles**  
Integration engineer, Azure DevOps Engineer.

**Responsibilities**  
- Version API revisions and policies in Azure Repos.  
- Deploy to dev/stage/prod APIM instances with approvals.  
- Manage named values and secrets via Key Vault references.  
- Run smoke tests against gateway URL post-deploy.  
- Document developer subscription keys rotation outside pipelines.  
- Integrate Application Insights for APIM diagnostics.  
- Align with networking (VNET integration) deployed from same IaC pipeline.  
- Track breaking API changes with Azure Boards.

---

## 24. SLOs and Azure Monitor Alerts as Release Quality Gates

**Description**  
Define SLO queries in Log Analytics; use release gates (Azure Monitor or custom REST) to block production promotion when error budget is burning.

**Skills**  
Log Analytics KQL, Azure Monitor alerts, `InvokeRESTAPI@1` gate, Azure Pipelines environments, work item integration.

**Roles**  
SRE, Azure DevOps Engineer.

**Responsibilities**  
- Document SLO definitions in Wiki with query IDs.  
- Implement gate that calls Azure Monitor metrics or Logs API.  
- Tune gate timeout and failure behavior (warn vs block).  
- Train release managers on override process with audit trail.  
- Link gate failures to incident process.  
- Review SLO thresholds quarterly.  
- Ensure service principal used by gate has least privilege.  
- Store gate scripts in Git with code review.

---

## 25. Compliance Automation: Export Azure DevOps & Azure Audit Logs

**Description**  
Scheduled pipelines pull Azure DevOps audit events (where available) and Azure Activity logs into Log Analytics or storage for SOC-style retention and reporting.

**Skills**  
Azure Monitor diagnostic settings, Log Analytics, `AzureCLI@2`, Azure DevOps audit REST APIs, storage accounts, retention policies.

**Roles**  
Security engineer, Azure DevOps Administrator, Compliance.

**Responsibilities**  
- Enable auditing features in Azure DevOps organization settings.  
- Automate export with managed identity or service principal.  
- Define retention aligned to policy; restrict access to export container.  
- Build workbooks or Power BI for common compliance questions.  
- Document evidence retrieval steps per audit request.  
- Alert on suspicious permission changes.  
- Test restore of audit data access annually.  
- Coordinate with Azure AD sign-in logs for full story.

---

## 26. Monorepo Build Acceleration with Pipeline Caching

**Description**  
Optimize Azure Pipelines for large .NET/npm monorepos using cache tasks, parallel jobs, and Microsoft-hosted larger agents where licensed.

**Skills**  
`Cache@2`, pipeline parallelism, matrix strategies, Azure Pipelines billing/parallel jobs, NuGet/npm caches, incremental build flags.

**Roles**  
Build engineer, Azure DevOps Engineer.

**Responsibilities**  
- Identify cache keys based on lockfiles and `azure-pipelines.yml` hash.  
- Split CI into shards using job matrix for test projects.  
- Measure before/after wall-clock time in Analytics.  
- Document cache invalidation troubleshooting.  
- Right-size pool vs self-hosted for cost/performance.  
- Avoid caching secrets or volatile paths.  
- Contribute template updates for org-wide reuse.  
- Track flaky test impact separately from cache issues.

---

## 27. Canary / Progressive Delivery to AKS with Azure Pipelines

**Description**  
Implement Flagger or manual weighted `kubectl`/`helm` steps orchestrated from Azure Pipelines with metric checks from Application Insights or Prometheus on AKS.

**Skills**  
AKS, Helm, Flagger (optional), `Kubernetes@1`, Application Insights queries in scripts, environment approvals, rollback parameters.

**Roles**  
Platform engineer, SRE, service owners.

**Responsibilities**  
- Define canary metrics and thresholds in Wiki.  
- Automate traffic split steps with clear pause for observation.  
- Wire rollback on failed health checks.  
- Label metrics for canary pods for query isolation.  
- Use production approvals before starting canary stage.  
- Document debugging steps for failed progressive delivery.  
- Keep pipeline idempotent for repeated runs.  
- Post-run attach summary comment to linked work item.

---

## 28. Data Factory / Synapse Pipeline CI/CD with Azure DevOps

**Description**  
Publish Azure Data Factory or Synapse artifacts using ARM-based publish from Azure Repos with environment-specific parameter files.

**Skills**  
ADF Git integration, ARM template export, `AzureResourceManagerTemplateDeployment@3`, Synapse workspace deployment, Azure DevOps environments.

**Roles**  
Data engineer, Azure DevOps Engineer.

**Responsibilities**  
- Structure ADF repo branches for collaboration with Azure DevOps.  
- Build publish pipeline that stops triggers, deploys, restarts triggers.  
- Parameterize linked services and IR names per environment.  
- Store secrets in Key Vault; reference in ARM parameters.  
- Test in dev workspace before promoting ARM to prod.  
- Document hotfix path for broken pipelines.  
- Link data incidents back to Boards.  
- Version ARM artifacts as build outputs.

---

## 29. Mobile Build Pipeline with Azure Pipelines + App Center / Store

**Description**  
CI for mobile apps using Azure Pipelines (Mac agents if needed), signing via Key Vault, and distribution through App Center or store submission tasks.

**Skills**  
Azure Pipelines macOS agents, code signing, App Center distribute task, secure files library, variable groups, YAML templates.

**Roles**  
Mobile DevOps, release manager.

**Responsibilities**  
- Protect signing assets with **Secure files** and restricted permissions.  
- Separate PR validation from release builds.  
- Integrate test flight / Play upload via extensions or scripts.  
- Map branches to release tracks in pipeline parameters.  
- Store artifacts in pipeline runs for traceability.  
- Document emergency rebuild procedure.  
- Align backend API deploy pipelines with mobile release calendar using Boards.  
- Monitor queue times for macOS pools and plan capacity.

---

## 30. Greenfield: New Azure DevOps Project + First Azure Production Deploy

**Description**  
End-to-end setup: Azure DevOps project, Repos default branch policies, YAML CI/CD, Azure subscription service connection, first App Service or AKS deploy with Wiki and Boards.

**Skills**  
Azure DevOps project creation, Repos, Pipelines, Environments, ARM/Bicep, Azure RBAC, Application Insights, Azure Wiki.

**Roles**  
Lead Azure DevOps Engineer, Azure admin, product stakeholder.

**Responsibilities**  
- Create project structure, teams, and area paths in Azure Boards.  
- Establish **Project Settings** permissions and group mappings from Azure AD groups.  
- Onboard first repo with sample YAML and walkthrough Wiki page.  
- Create production environment with required reviewers.  
- Deploy minimal hello-world Azure resource via pipeline with tags.  
- Enable branch policies and build validation on main.  
- Complete handoff checklist: on-call, runbooks, dashboards.  
- Capture retrospective items for scaling to more teams.

---

*All projects assume **Azure DevOps** (cloud or Azure DevOps Server) as the delivery hub and **Microsoft Azure** as the primary deployment target where applicable.*
