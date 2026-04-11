# Migration Projects (Azure DevOps)

Thirty migration initiatives where **Azure DevOps** is the system of record for source control, pipelines, work tracking, and artifacts while moving workloads onto **Microsoft Azure** or modernizing delivery practices inside the same organization.

---

## 1. Jenkins / TeamCity / Bamboo → Azure Pipelines

**Description**  
Migrate build and release automation to YAML (and multi-stage) Azure Pipelines in **Azure Repos**, preserving triggers, artifacts, secrets, and deployment targets on Azure.

**Skills**  
Azure Pipelines YAML, service connections (ARM, ACR, Kubernetes), variable groups, Azure Key Vault integration, Jenkinsfile-to-YAML mapping, Azure Artifacts feeds.

**Roles**  
Azure DevOps Engineer, Build/Release owner per application, Security (secrets review).

**Responsibilities**  
- Inventory existing jobs, plugins, credentials, and agent labels.  
- Recreate equivalent stages using templates and `pool` specifications.  
- Replace Jenkins credentials with service connections and Key Vault references.  
- Parallel-run Azure Pipelines against legacy CI until parity sign-off.  
- Update **Azure Repos** branch policies to require new pipeline builds.  
- Migrate artifact flows to **Azure Artifacts** or ACR as appropriate.  
- Document queue URLs, agent requirements, and troubleshooting in **Azure Wiki**.  
- Decommission legacy CI servers after archival of job configs.

---

## 2. GitHub / GitLab → Azure Repos

**Description**  
Move repositories, PR history (where migrated), webhooks, and branch protections into **Azure Repos** while reconnecting **Azure Pipelines** to the new remote.

**Skills**  
Azure Repos Git, import tools, branch policies, PR templates, `resources.repositories` in YAML, service hooks, PAT scopes for migration.

**Roles**  
Azure DevOps Administrator, Engineering lead, Azure DevOps Engineer.

**Responsibilities**  
- Plan cutover window and communication to all contributors.  
- Import repos or mirror-push with LFS considerations.  
- Recreate branch policies, reviewers, and build validation pipelines.  
- Re-point **Azure Pipelines** `checkout` and triggers to Azure Repos.  
- Migrate or recreate GitHub Actions as Azure Pipelines YAML.  
- Update service hooks (Teams, Slack) to Azure DevOps events.  
- Archive old remotes read-only for compliance retention.  
- Run pilot team migration before org-wide move.

---

## 3. TFVC → Git in Azure Repos

**Description**  
Convert Team Foundation Version Control histories and folder structures to Git repositories with branch policies and new YAML pipelines in the same Azure DevOps project.

**Skills**  
TFVC to Git migration tools, Azure Repos, branch policies, Azure Pipelines YAML, large binary handling (Git LFS), work item linking.

**Roles**  
Azure DevOps Administrator, Application owner, Azure DevOps Engineer.

**Responsibilities**  
- Map TFVC branches/folders to Git repo layout.  
- Execute migration preserving history where tooling allows.  
- Establish `main` and release branch strategy with policies.  
- Create new YAML pipelines replacing XAML or classic TFVC builds.  
- Train developers on Git workflows vs TFVC.  
- Link commits to **Azure Boards** work items (`#123` / AB#).  
- Retire TFVC paths after freeze and backup.  
- Document rollback plan (read-only TFVC snapshot).

---

## 4. On-Premises VMs → Azure IaaS (Pipelines for Cutover)

**Description**  
Use **Azure Migrate** for assessment/replication while orchestrating cutover checklists, IaC deployment of landing zone, and post-migration validation via **Azure Pipelines**.

**Skills**  
Azure Migrate, Azure VM, Bicep/ARM from Azure Pipelines, Azure DevOps Boards for wave tracking, Azure CLI tasks, service connections.

**Roles**  
Migration lead, Azure engineer, Azure DevOps Engineer, application owner.

**Responsibilities**  
- Track migration waves as **Azure Boards** epics/features.  
- Deploy target networking and VMs (if greenfield) via IaC pipeline.  
- Automate smoke tests after cutover using pipeline against new endpoints.  
- Store runbooks and IP/DNS checklists in **Azure Wiki**.  
- Use pipeline variables per wave for subscription/resource group.  
- Document agent connectivity if self-hosted agents join migrated VNets.  
- Close work items when stability period completes.  
- Attach cost and architecture diagrams to project Wiki.

---

## 5. SQL Server On-Prem → Azure SQL / Managed Instance

**Description**  
Database migration with cutover orchestration tracked in **Azure Boards**; connection strings and Key Vault updates applied through **Azure Pipelines** to App Service/AKS.

**Skills**  
Azure SQL, DMA / DMS patterns, `SqlAzureDacpacDeployment@1`, Key Vault, Azure Pipelines environments, variable groups, private endpoint networking.

**Roles**  
DBA, Azure DevOps Engineer, developer, migration lead.

**Responsibilities**  
- Document migration steps and backout in Wiki-linked work items.  
- Pipeline stages for schema deploy to staging Azure SQL before prod.  
- Update app settings via pipeline using Key Vault references.  
- Gate production cutover with approvals and maintenance window tasks on Boards.  
- Store Flyway/SQL scripts in **Azure Repos**.  
- Automate post-migration validation queries as pipeline job.  
- Rotate SQL credentials through Key Vault + pipeline secret sync pattern.  
- Mark Boards work items done after monitoring burn-in.

---

## 6. Classic Azure Pipelines → Full YAML in Git

**Description**  
Eliminate classic build/release editors by moving all logic to `azure-pipelines.yml` (or multi-pipeline) in **Azure Repos** with environments and checks.

**Skills**  
Classic pipeline export, YAML schema, deployment jobs, environments, task group decomposition into templates, retention settings.

**Roles**  
Azure DevOps Engineer, application teams.

**Responsibilities**  
- Inventory classic definitions and variable groups used.  
- Rewrite as YAML with `stages` / `deployment` jobs for clarity.  
- Replace visual task groups with `template:` steps.  
- Map classic “artifact feeds” to modern **Azure Artifacts** tasks.  
- Parallel validation; switch branch policies to YAML build.  
- Archive classic definitions.  
- Update onboarding docs in **Azure Wiki**.  
- Use **Azure Boards** tasks to track per-team conversion.

---

## 7. Azure DevOps Server → Azure DevOps Services (Cloud)

**Description**  
Migrate collections/projects from on-premises **Azure DevOps Server** to **dev.azure.com** including repos, pipelines (YAML preferred), work items, and build agents.

**Skills**  
Azure DevOps Server upgrade path, migration tools / manual import, Azure AD connect for identities, agent re-registration, service endpoint recreation.

**Roles**  
Azure DevOps Administrator, infrastructure engineer, security.

**Responsibilities**  
- Map Windows auth / AD groups to **Azure AD** backed groups in cloud.  
- Migrate Git repos and validate pipeline YAML still valid.  
- Recreate service connections to Azure subscriptions (federated where possible).  
- Plan URL changes for service hooks and integrations.  
- Communicate PAT rotation and new org URL to all users.  
- Rebuild self-hosted agent pools pointing to cloud org.  
- Validate **Azure Boards** process template compatibility.  
- Run pilot project migration before full cutover.

---

## 8. SonarQube / External Quality Gate → Azure DevOps Native + Defender

**Description**  
Align code quality gates with **Azure DevOps** PR experience: branch policies, optional SonarQube extension or Defender for DevOps, and required build validation pipelines.

**Skills**  
Branch policies, PR status checks, SonarQube extension (optional), Microsoft Defender for DevOps, YAML quality stages, Azure Boards bugs from findings.

**Roles**  
Security engineer, Azure DevOps Engineer, dev leads.

**Responsibilities**  
- Configure build validation pipeline that runs analysis on each PR.  
- Map old quality profiles to new pipeline steps.  
- Create work items from recurring issues via Boards rules or manual triage.  
- Document developer fix workflow in Wiki.  
- Remove duplicate gates between old and new systems.  
- Tune false positives with suppression files in **Azure Repos**.  
- Report metrics on defect density pre/post migration.  
- Train teams on new PR checks location in Azure DevOps UI.

---

## 9. Octopus Deploy / Release Management → Azure Pipelines Environments

**Description**  
Recreate deployment channels, tenants (as appropriate), and approvals using **Azure Pipelines** **Environments**, checks, and multi-stage YAML.

**Skills**  
Environments, deployment jobs, resource tags, approvals, checks, variable groups per stage, Azure Boards release notes.

**Roles**  
Release manager, Azure DevOps Engineer.

**Responsibilities**  
- Map Octopus lifecycles to environment sequence in YAML.  
- Configure approver groups matching prior roles.  
- Replace Octopus variables with variable groups + Key Vault.  
- Migrate deployment scripts into **Azure Repos** scripts folder.  
- Use pipeline resources to chain build → release.  
- Document per-environment configuration matrix in Wiki.  
- Run parallel releases until confidence is high.  
- Decommission legacy deploy server licensing.

---

## 10. ServiceNow Change → Azure DevOps Boards + Pipelines Traceability

**Description**  
Shift detailed technical change tracking for app releases to **Azure Boards** while integrating optional **Azure Pipelines** service hook or REST to ServiceNow for CAB records.

**Skills**  
Azure Boards work items, **InvokeRESTAPI@1**, service hooks, YAML custom task scripts, process customization, query-based dashboards.

**Roles**  
Change manager, Azure DevOps Administrator, release manager.

**Responsibilities**  
- Define work item type mapping for standard vs emergency changes.  
- Automate creation/update of external change tickets from pipeline (if required).  
- Link pipeline runs to work items using built-in integration.  
- Train teams on dual-system hygiene to avoid duplicate effort.  
- Build queries for “changes this week by team.”  
- Document which fields are authoritative in Azure DevOps vs ITSM.  
- Review integration failures in pipeline logs.  
- Quarterly simplification pass on redundant fields.

---

## 11. Azure Container Registry Migration (Consolidate Registries)

**Description**  
Consolidate multiple ACR instances into a central registry; update **Azure Pipelines** service connections, `Docker@2` tasks, and deployment manifests accordingly.

**Skills**  
ACR import tools, `Docker@2`, service connections, Azure CLI in pipeline, Helm values in Git, Azure Repos.

**Roles**  
Platform engineer, Azure DevOps Engineer, security.

**Responsibilities**  
- Inventory images and tags per registry from Boards checklist work item.  
- Copy images with `az acr import` via automated pipeline.  
- Update YAML to new login server and service connection name.  
- Rotate any embedded registry URLs in Helm/Kubernetes manifests in Git.  
- Validate pull secrets on AKS after migration.  
- Document developer `docker login` changes in Wiki.  
- Retire old ACR after retention period.  
- Attach evidence of vulnerability scan pass to pipeline.

---

## 12. Self-Hosted Agents → Azure VMSS Agent Pools

**Description**  
Replace static build VMs with **Azure Pipelines** VMSS agent pools in Azure for elasticity; migrate capabilities and pipeline `pool` references.

**Skills**  
VMSS agent pools, Azure DevOps organization settings, agent images, pipeline YAML `pool`, networking to Azure DevOps, managed identity.

**Roles**  
Azure DevOps Administrator, infrastructure engineer.

**Responsibilities**  
- Clone installed software list from old agents into new image definitions.  
- Build image via Azure Image Builder pipeline in **Azure DevOps**.  
- Cut over teams in waves; update YAML pool names.  
- Monitor queue times and failure rates in Analytics.  
- Decommission old agent VMs.  
- Document pool selection guidelines in Wiki.  
- Align subnets with private connectivity requirements.  
- Use Boards to track each team’s pool migration task.

---

## 13. npm / NuGet.org → Azure Artifacts Feeds

**Description**  
Redirect package restore and publish to **Azure Artifacts** upstreams; update **Azure Pipelines** authentication and `.npmrc` / `NuGet.config` in **Azure Repos**.

**Skills**  
Azure Artifacts, `npm authenticate`, `NuGetCommand@2`, feed views, pipeline identity permissions, `nuget.config` in repo root.

**Roles**  
Build engineer, Azure DevOps Engineer, developers.

**Responsibilities**  
- Create org or project feeds with upstream sources.  
- Update pipelines to use `npm ci` / `dotnet restore` against feed.  
- Migrate internal packages into `@local` view.  
- Communicate developer machine setup (`vsts-npm-auth`, etc.).  
- Remove hardcoded API keys from old CI systems.  
- Validate PR builds for all affected repos.  
- Document rollback to public registries for emergency.  
- Track open migration tasks on **Azure Boards**.

---

## 14. Azure DevOps Organization Consolidation (Merge Orgs)

**Description**  
Merge two **Azure DevOps organizations** into one: project rename, repo transfer, pipeline recreation, identity mapping, and billing consolidation.

**Skills**  
Azure DevOps org admin, project import/export patterns, Git push mirrors, Azure AD guest/B2B, service connection recreation, billing setup.

**Roles**  
Azure DevOps org admin, security, program manager.

**Responsibilities**  
- Inventory all projects, pipelines, and extensions in source org.  
- Plan target org structure and naming standards.  
- Migrate repos via git push mirror; recreate Boards process if needed.  
- Recreate service connections (cannot always be exported).  
- Map users and groups to unified **Azure AD** groups.  
- Communicate URL and PAT changes.  
- Validate pipeline runs in target before org decommission.  
- Archive audit logs from source org per retention policy.

---

## 15. Azure Kubernetes Service: Cluster Rebuild + Pipeline Retarget

**Description**  
Rebuild AKS on new version or subscription; update all **Kubernetes service connections**, secret backends, and YAML deploy stages in **Azure Pipelines**.

**Skills**  
AKS, `Kubernetes@1`, `HelmDeploy@0`, federated credentials, Azure Key Vault CSI, Bicep for cluster, Azure Repos for manifests.

**Roles**  
Platform engineer, Azure DevOps Engineer, SRE.

**Responsibilities**  
- Deploy new cluster via IaC pipeline from **Azure Repos**.  
- Create new Kubernetes service connection; restrict namespaces.  
- Blue/green or parallel deploy validation against new API server.  
- Update variable groups with new cluster DNS and resource IDs.  
- Migrate workloads with staged namespace cutover.  
- Document agent egress if self-hosted agents deploy to private API.  
- Use **Azure Boards** for namespace migration checklist.  
- Decommission old cluster after traffic drain.

---

## 16. Azure Key Vault: Vault Consolidation & Pipeline Variable Migration

**Description**  
Merge multiple Key Vaults into fewer instances; update **Azure Pipelines** variable groups, `AzureKeyVault@2` tasks, and ARM parameter files.

**Skills**  
Key Vault RBAC, secret naming, variable group linking, `AzureKeyVault@2`, Bicep `keyVaultSecretsUser`, service principal permissions.

**Roles**  
Security engineer, Azure DevOps Engineer.

**Responsibilities**  
- Inventory secrets referenced in YAML and library groups.  
- Copy secrets with automation pipeline and validation readback.  
- Update variable groups to new vault URI references.  
- Coordinate rotation of any duplicated secret values.  
- Test all critical pipelines in non-prod first.  
- Document naming convention in Wiki.  
- Remove obsolete secrets after soak period.  
- Track tasks per application on **Azure Boards**.

---

## 17. Azure DevOps Process Template Change (Agile → Scrum / CMMI)

**Description**  
Migrate team process while preserving **Azure Boards** history: work item type mapping, queries, dashboards, and pipeline integration fields.

**Skills**  
Process inheritance, work item type mapping, WIQL queries, dashboards, Azure Boards REST API (optional bulk edit).

**Roles**  
Process administrator, Scrum Master, Azure DevOps Administrator.

**Responsibilities**  
- Export/ document existing fields and states per type.  
- Create inherited process with required fields only.  
- Map states during project process change (where supported).  
- Update queries and sprint boards for new workflow.  
- Communicate training dates and wiki updates.  
- Validate pipeline work item integration still links correctly.  
- Run pilot team before org-wide process swap.  
- Archive old process documentation.

---

## 18. Azure DevOps Test Plans from Spreadsheet / Zephyr

**Description**  
Move test cases into **Azure Test Plans**; link test suites to **Azure Boards** requirements and run tests from **Azure Pipelines** with published results.

**Skills**  
Azure Test Plans, test case import (CSV), `PublishTestResults@2`, association to builds/releases, permissions.

**Roles**  
QA lead, Azure DevOps Engineer, PM.

**Responsibilities**  
- Define test plan structure per product area.  
- Import or recreate test cases with correct IDs for traceability.  
- Configure pipeline to publish TRX/JUnit results to Test Plans.  
- Map testers to **Azure DevOps** access levels (Basic + Test Plans).  
- Retire old tool licenses after parallel run.  
- Document exploratory testing workflow in Wiki.  
- Build query-based quality dashboards.  
- Align acceptance criteria fields between Boards and Test Plans.

---

## 19. Azure DevOps Wiki from Confluence / SharePoint

**Description**  
Migrate runbooks and architecture pages to **Azure Wiki** (Git-backed) for co-location with **Azure Repos** and pipelines.

**Skills**  
Azure Wiki, Markdown, Mermaid diagrams, Git structure for wiki, permission inheritance, search.

**Roles**  
Technical writer, Azure DevOps Engineer, SMEs.

**Responsibilities**  
- Choose code wiki vs project wiki per retention needs.  
- Convert pages to Markdown with automated scripts where possible.  
- Fix internal links and attach images to Git.  
- Establish review process via PR on wiki repo (if code wiki).  
- Train teams on editing and TOC structure.  
- Sunset old wiki with read-only archive.  
- Link wiki pages from **Azure Boards** work item descriptions.  
- Schedule quarterly stale page review.

---

## 20. Azure DevOps Permissions Model Hardening Migration

**Description**  
Move from broad **Project Administrators** membership to least-privilege **Azure AD** groups, custom groups, and pipeline-scoped permissions.

**Skills**  
Azure DevOps security groups, RBAC at org/project/object level, pipeline permissions, “Limit job authorization scope,” audit log review.

**Roles**  
Azure DevOps Administrator, security engineer.

**Responsibilities**  
- Inventory current owners and contributors per project.  
- Create **Azure AD** groups mapped to Azure DevOps groups.  
- Enable least privilege for build service accounts.  
- Restrict who can create service connections and agent pools.  
- Document escalation path for emergency access.  
- Communicate permission changes before enforcement.  
- Validate pipelines still succeed under new model.  
- Use **Azure Boards** for exception tracking.

---

## 21. Azure DevOps Extensions: Trim & Replace Third-Party Tasks

**Description**  
Audit installed marketplace extensions; replace risky/unused ones with Microsoft tasks or inline scripts in **Azure Pipelines** from **Azure Repos**.

**Skills**  
Extension management, YAML task equivalents, `PowerShell@2`, `AzureCLI@2`, extension approval policies, security review.

**Roles**  
Azure DevOps org admin, security, platform engineer.

**Responsibilities**  
- Export list of extensions and last usage date from pipeline search.  
- Identify extensions with broad OAuth scopes.  
- Rewrite pipelines to remove dependency where feasible.  
- Test affected pipelines in non-prod.  
- Uninstall unused extensions.  
- Document approved extension catalog in Wiki.  
- Require CAB for new extension installs.  
- Track remediation in **Azure Boards**.

---

## 22. Azure DevOps Audit Log Retention to Log Analytics

**Description**  
Migration of audit visibility from ad-hoc UI queries to centralized **Log Analytics** using scheduled **Azure Pipelines** or Azure Automation.

**Skills**  
Azure DevOps audit REST API, `AzureCLI@2`, Log Analytics ingestion, managed identity, workspace tables, KQL.

**Roles**  
Security engineer, Azure DevOps Administrator.

**Responsibilities**  
- Enable organization-level auditing features.  
- Implement secure automation identity with least privilege.  
- Parse and ship events to Log Analytics on schedule.  
- Build detection queries for sensitive actions (e.g., permission changes).  
- Document evidence pull procedure for audits.  
- Test failure alerting when export pipeline breaks.  
- Align retention with compliance.  
- Review queries quarterly for noise.

---

## 23. Azure DevOps Billing / Parallel Jobs Optimization Migration

**Description**  
Transition from ad-hoc Microsoft-hosted parallelism to right-sized **Azure Pipelines** parallel job counts and mix of self-hosted pools; document in Wiki and **Azure Boards** cost epic.

**Skills**  
Azure DevOps billing, parallel jobs, self-hosted agents, pipeline analytics, job splitting, Microsoft-hosted larger runners (optional).

**Roles**  
Engineering manager, Azure DevOps Administrator, FinOps.

**Responsibilities**  
- Analyze peak concurrent jobs from Analytics.  
- Identify pipelines wasting parallelism (redundant triggers).  
- Implement path filters and cancellation of redundant runs.  
- Purchase or reallocate parallel jobs to match true peak.  
- Move heavy jobs to self-hosted VMSS where cheaper.  
- Document pool selection standards.  
- Track monthly spend vs queue time SLA.  
- Present outcomes in leadership review.

---

## 24. Azure DevOps Multi-Project → Single Project (Repo-Per-Project Unwind)

**Description**  
Consolidate many small **Azure DevOps projects** into one project with multiple repos for simpler administration and shared pipelines templates.

**Skills**  
Project settings, repo migration git push, Boards area path design, pipeline path filters, permission inheritance, billing implications.

**Roles**  
Azure DevOps Administrator, program manager, team leads.

**Responsibilities**  
- Define target area paths and teams in unified project.  
- Move repos and recreate branch policies.  
- Merge or archive duplicate process templates.  
- Update service connections naming conventions.  
- Communicate new project URL and bookmarks.  
- Migrate dashboards and queries.  
- Run pilot consolidation.  
- Decommission empty projects after validation.

---

## 25. Azure DevOps Service Hooks & Integrations URL Migration

**Description**  
When org URL, DNS, or third-party endpoints change, systematically update **service hooks**, **Teams** connectors, and pipeline `InvokeRESTAPI` tasks.

**Skills**  
Service hooks UI, JSON payloads, secret variables, REST task auth, Teams connectors, Azure DevOps permissions.

**Roles**  
Azure DevOps Engineer, collaboration admin.

**Responsibilities**  
- Export inventory of hooks per project.  
- Test webhook delivery in staging channel first.  
- Rotate shared secrets used in hooks.  
- Update YAML variables for REST endpoints.  
- Document owner per integration in Wiki.  
- Remove orphaned hooks.  
- Monitor failed deliveries after cutover.  
- Track fixes via **Azure Boards** bugs.

---

## 26. Azure DevOps + Azure AD Group Sync Rework

**Description**  
Migrate from manually maintained **Azure DevOps** groups to **Azure AD** group-based access with rules for project, repo, and pipeline permissions.

**Skills**  
Azure AD group sync, Azure DevOps organization settings, conditional access awareness, guest access policies, least privilege.

**Roles**  
Identity administrator, Azure DevOps org admin.

**Responsibilities**  
- Map roles (Reader, Contributor, Build Admin) to **Azure AD** groups.  
- Remove duplicate nested memberships.  
- Validate guest access still meets compliance.  
- Communicate access changes and review dates.  
- Test pipeline permissions for build service identities.  
- Document break-glass group usage.  
- Quarterly access review using **Azure AD** access reviews.  
- Log changes in **Azure Boards** change record.

---

## 27. Azure DevOps Pipeline Secret Scanning Remediation Migration

**Description**  
After enabling secret scanning, migrate exposed secrets out of **Azure Repos** history (rotate + optional history rewrite policy) and into **Key Vault** / variable groups.

**Skills**  
Git history cleanup strategies, Key Vault, variable groups, branch policies, PR scanning, coordination with security.

**Roles**  
Security engineer, Azure DevOps Engineer, repo owners.

**Responsibilities**  
- Triage scanner hits and confirm true positives.  
- Rotate all exposed credentials regardless of history rewrite.  
- Replace literals in YAML with secret variables.  
- Decide per repo: BFG/filter-repo vs rotate-only policy.  
- Enforce pre-merge scanning in branch policies.  
- Document developer guidance in Wiki.  
- Track completion per repo in **Azure Boards**.  
- Post-mortem on how secrets entered Git.

---

## 28. Azure DevOps Android / iOS Pipeline Migration to Unified YAML

**Description**  
Consolidate fragmented mobile classic builds into one **Azure Pipelines** YAML per app using secure files, macOS pools, and **Azure Artifacts** for dependencies.

**Skills**  
macOS agents, secure files, signing, YAML templates, App Center tasks (optional), variable groups.

**Roles**  
Mobile DevOps, Azure DevOps Engineer.

**Responsibilities**  
- Inventory signing certs and provisioning profiles in secure library.  
- Recreate build steps as YAML with explicit Xcode / Gradle tasks.  
- Migrate artifact publication to pipeline artifacts or **Azure Artifacts**.  
- Test PR pipeline vs release pipeline separation.  
- Document local vs CI differences in Wiki.  
- Use **Azure Boards** for device-test checklist.  
- Retire classic mobile definitions.  
- Monitor macOS queue saturation.

---

## 29. Azure DevOps Dashboards & Analytics Query Migration

**Description**  
Recreate stakeholder dashboards using **Azure DevOps** built-in Analytics views, Power BI OData (optional), and work item queries replacing spreadsheet tracking.

**Skills**  
WIQL, dashboard widgets, Analytics views, Power BI Azure DevOps connector, Boards customization.

**Roles**  
Scrum Master, Azure DevOps Engineer, PMO.

**Responsibilities**  
- Define KPIs: lead time, cycle time, burndown, pipeline pass rate.  
- Build shared queries and folders per team.  
- Create dashboards pinned to team homepages.  
- Train leads on reading velocity and scope creep signals.  
- Deprecate duplicate Excel reports.  
- Validate permissions for sensitive work item fields.  
- Iterate widget layout based on feedback.  
- Link dashboards from **Azure Wiki** landing page.

---

## 30. Program: Azure DevOps Center of Excellence Rollout

**Description**  
Organization-wide adoption program: standard **Azure DevOps** project layout, mandatory YAML templates, **Boards** taxonomy, and training—all tracked on a master **Azure Boards** program.

**Skills**  
Azure DevOps governance, process templates, YAML template libraries, training delivery, reporting, stakeholder management.

**Roles**  
Program manager, Azure DevOps CoE lead, chapter leads per business unit.

**Responsibilities**  
- Publish reference architecture in **Azure Wiki**.  
- Maintain template repo consumed via `resources.repositories`.  
- Run office hours and capture FAQs into Wiki.  
- Score maturity per team; prioritize coaching.  
- Report adoption metrics (YAML %, policy coverage) monthly.  
- Coordinate extension and marketplace policy.  
- Align with Azure AD and security on access patterns.  
- Close program epic when KPIs sustained for two quarters.

---

*Migrations are described in terms of **Azure DevOps** features and **Microsoft Azure** services; third-party tools appear only as migration sources or optional integrations.*
