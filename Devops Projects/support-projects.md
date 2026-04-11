# Support Projects (Azure DevOps)

Thirty support initiatives focused on operating **Azure DevOps** organizations, keeping **Azure Pipelines** reliable, and helping engineering teams deliver on **Microsoft Azure** using Azure DevOps features day to day.

---

## 1. Azure DevOps Organization Health & Incident Triage

**Description**  
First-line response when **dev.azure.com** or **Azure DevOps Server** experiences outages, degraded performance, or org-wide misconfiguration affecting pipelines and repos.

**Skills**  
Azure DevOps service status pages, org/project settings navigation, **az devops** CLI, support case opening with Microsoft, internal comms templates.

**Roles**  
Azure DevOps Administrator, SRE liaison, engineering manager.

**Responsibilities**  
- Confirm scope (org-wide vs single project vs regional) using status and user reports.  
- Post updates to Teams/Slack with links to Azure DevOps **Status** and workaround steps.  
- Identify blocked scenarios: sign-in, PRs, pipeline queue, artifact restore.  
- Escalate to Microsoft support with org ID, timestamps, and correlation IDs.  
- Track internal incidents in **Azure Boards** with severity.  
- After resolution, capture timeline in **Azure Wiki** post-incident note.  
- Review whether self-hosted agents or IP allowlists contributed.  
- Schedule follow-up tasks (e.g., retry failed releases).

---

## 2. Azure Pipelines Break-Fix Support Queue

**Description**  
Operate a **Azure Boards**-backed queue for “build broken,” “release failed,” and “agent stuck” tickets with SLAs and clear handoff to app teams when root cause is code.

**Skills**  
Pipeline run logs, task diagnostics, YAML debugging, agent pool issues, service connection errors, **Azure Artifacts** auth failures.

**Roles**  
Azure DevOps support engineer, platform engineer, application on-call (code issues).

**Responsibilities**  
- Triage within SLA: platform misconfig vs test failure vs compile error.  
- Requeue failed jobs after transient Azure DevOps platform errors.  
- Fix mis-scoped service connections or expired secrets with security process.  
- Point developers to failing log sections and task names.  
- Document recurring flakes as **Azure Boards** bugs to app teams.  
- Escalate Microsoft-hosted agent image regressions to extension/docs.  
- Maintain FAQ in **Azure Wiki** for top ten failures.  
- Report weekly volume and MTTR to leadership.

---

## 3. Self-Hosted Agent Pool Operations Support

**Description**  
Day-to-day care for **Azure Pipelines** self-hosted agents and **VMSS** pools: offline agents, disk full, TLS to Azure DevOps, and software drift.

**Skills**  
Agent diagnostics (`Agent.Worker` logs), VMSS scaling, PAT/identity rotation, firewall rules, image update pipelines, pool permissions.

**Roles**  
Infrastructure engineer, Azure DevOps Administrator.

**Responsibilities**  
- Monitor for agents offline or not picking jobs.  
- Clean workspace directories and reclaim disk safely.  
- Patch golden images and roll out via VMSS or replacement VMs.  
- Verify connectivity to `dev.azure.com` or Azure DevOps Server URL.  
- Align agent version with org policy warnings.  
- Document per-pool installed tool versions in **Azure Wiki**.  
- Handle emergency pool scale-up during release crunch.  
- Log changes as **Azure Boards** tasks with change records.

---

## 4. Service Connection & Azure Subscription Auth Support

**Description**  
Support engineers when ARM, ACR, or Kubernetes **service connections** fail authentication after password rotation, cert expiry, or subscription move.

**Skills**  
Service connection types (Workload identity federation, secret-based), **Azure Resource Manager** troubleshooting, **Azure AD** app registrations, Key Vault (optional), pipeline error interpretation.

**Roles**  
Azure DevOps Administrator, cloud identity engineer, security.

**Responsibilities**  
- Validate federated credential configuration vs pipeline OIDC claims.  
- Coordinate secret rotation with least-privilege service principals.  
- Test connections from **Project Settings** and document outcomes.  
- Update YAML only when connection names or scopes change.  
- Avoid sharing service principals across unrelated projects without approval.  
- Record approvals for elevated subscription scope connections.  
- Train teams on using scoped RBAC for pipeline identities.  
- Track open connection issues on **Azure Boards**.

---

## 5. Azure Repos: Branch Policies & PR Merge Support

**Description**  
Help teams resolve blocked merges: failing build validation, missing reviewers, comment resolution requirements, and policy bypass requests.

**Skills**  
Branch policies, required reviewers, build validation pipeline selection, bypass permissions, merge conflicts, **Azure Repos** permissions.

**Roles**  
Azure DevOps support engineer, repo admin, team lead.

**Responsibilities**  
- Explain which policy failed and link to the blocking pipeline run.  
- Coordinate bypass only per governance with audit justification.  
- Fix misconfigured build validation targeting wrong YAML file.  
- Assist with large-file and LFS issues during push/PR.  
- Document policy templates for new repos in **Azure Wiki**.  
- Escalate permission errors (`TF401027`) to project admins.  
- Monitor for policy bypass abuse in audit logs.  
- Suggest optional path filters to speed validation pipelines.

---

## 6. Azure Artifacts: Restore & Publish Failure Support

**Description**  
Resolve `401`, `403`, feed not found, and upstream throttling issues for **Azure Artifacts** in **Azure Pipelines** and developer machines.

**Skills**  
Feed permissions, `pipelines` identity, `nuget.config` / `.npmrc`, upstream sources, `NuGetCommand@2` / npm authenticate tasks.

**Roles**  
Azure DevOps support engineer, build owner.

**Responsibilities**  
- Verify project vs organization feed scope and contributor rights.  
- Fix missing `npm authenticate` or `NuGet.config` in repo.  
- Restore upstream connectivity to npmjs.org or NuGet.org.  
- Purge poisoned local caches when instructed with safety.  
- Document developer VS / VS Code credential setup.  
- Track recurring feed issues as platform improvements.  
- Coordinate storage quota increases with billing admin.  
- Attach resolution steps to **Azure Wiki** troubleshooting.

---

## 7. Azure Boards: Work Item, Query, and Sprint Support

**Description**  
Support Scrum Masters and leads with misconfigured areas/iterations, broken queries, permission errors, and integration with **Azure Pipelines** (development links).

**Skills**  
Area paths, iterations, WIQL, boards column mapping, **Azure Boards** permissions, `#AB` commit linking, process inheritance basics.

**Roles**  
Process administrator, Azure DevOps support engineer, Scrum Master.

**Responsibilities**  
- Fix “work item not visible” issues via area path and permissions.  
- Rebuild broken shared queries and dashboards widgets.  
- Align iteration dates across teams in shared calendar.  
- Troubleshoot why commits don’t link (mention format, repo mapping).  
- Document field usage standards to reduce customization debt.  
- Assist with bulk edits via Excel or CSV import cautiously.  
- Escalate process template changes to org admin.  
- Capture frequent questions in **Azure Wiki** FAQ.

---

## 8. Azure Test Plans & Published Results Support

**Description**  
Help QA interpret **Azure Pipelines** `PublishTestResults@2` outcomes, test plan permissions, and flaky test configuration in YAML.

**Skills**  
Test Plans licensing, test result formats (TRX, JUnit), pipeline test reporting UI, flaky test settings, retention.

**Roles**  
QA lead, Azure DevOps support engineer.

**Responsibilities**  
- Verify users have correct access level for Test Plans features.  
- Debug missing test attachments or wrong build association.  
- Align test run titles with **Azure Boards** test suites.  
- Document how to re-run failed tests from pipeline.  
- Coordinate with devs when failures are environment-related.  
- Tune flaky test retry settings where appropriate.  
- Clean old test results per retention policy guidance.  
- Log tooling gaps as **Azure Boards** feature requests.

---

## 9. Azure Wiki Read/Write & Permission Support

**Description**  
Resolve **Azure Wiki** access issues, broken Markdown, large attachment problems, and guide teams on code wiki PR workflows.

**Skills**  
Project wiki vs code wiki, Git-backed wiki PRs, Markdown, Mermaid, image hosting in repo, permissions inheritance.

**Roles**  
Technical writer liaison, Azure DevOps support engineer.

**Responsibilities**  
- Fix permission denied for editors vs readers.  
- Help recover deleted wiki pages from Git history (code wiki).  
- Standardize heading hierarchy and TOC patterns.  
- Move sensitive content out of public projects if misfiled.  
- Train on linking wiki from **Azure Boards** and pipelines.  
- Archive duplicate wikis after consolidation.  
- Respond to search-not-finding-page issues (index delay).  
- Track documentation debt as work items.

---

## 10. Azure DevOps Permissions & Access Request Fulfillment

**Description**  
Process daily access requests: add to **Azure AD** groups mapped to **Azure DevOps**, grant repo or pipeline permissions, and time-bound elevation.

**Skills**  
Organization/project security groups, **Azure AD** group nesting, PAT guidance (discourage for automation), least privilege, audit logging.

**Roles**  
Azure DevOps Administrator, identity administrator.

**Responsibilities**  
- Validate manager or product owner approval per policy.  
- Use **Azure AD** groups instead of one-off user adds when standard exists.  
- Grant **Build Administrator** or **Release Administrator** only when justified.  
- Set calendar reminders to remove temporary access.  
- Document break-glass account usage separately.  
- Respond to `TF401019` / `VS403474` style errors with root cause.  
- Never share PATs; prefer federated workload or service principals.  
- Log completed requests in ticketing or **Azure Boards**.

---

## 11. Azure Pipelines YAML Syntax & Template Error Helpdesk

**Description**  
Assist developers fixing schema errors, expression failures, and template parameter mismatches in `azure-pipelines.yml`.

**Skills**  
YAML anchors vs Azure Pipelines expressions, `template` compile errors, **Validate** tab in pipeline editor, VS Code Azure Pipelines extension.

**Roles**  
Azure DevOps Engineer, senior developer volunteers.

**Responsibilities**  
- Read compiler errors and map to line/column in repo.  
- Explain differences between runtime and compile-time expressions.  
- Promote use of template `parameters` defaults to reduce duplication.  
- Catch unsafe `bash` injection patterns in user inputs.  
- Point to official schema docs in **Azure Wiki** shortcuts.  
- Encourage small PRs for pipeline changes with reviewers.  
- Track confusing errors for internal style guide updates.  
- Escalate product bugs to Microsoft feedback channels when confirmed.

---

## 12. Azure DevOps Billing, Parallel Jobs & Rate Limit Support

**Description**  
Support teams hitting “no hosted parallelism,” queue stalls, or unexpected billing line items for **Azure Pipelines**.

**Skills**  
Parallel job purchasing, **Organization Settings → Billing**, self-hosted fallback, pipeline analytics for concurrency, Microsoft account/subscription linkage.

**Roles**  
Engineering manager, Azure DevOps org admin, FinOps.

**Responsibilities**  
- Confirm org billing owner and active parallel job count.  
- Differentiate Microsoft-hosted vs self-hosted queue backlogs.  
- Recommend job splitting or path filters to reduce waste.  
- Open Microsoft support cases for suspected platform throttling.  
- Document escalation path when purchases don’t reflect within SLA.  
- Advise on mixing VMSS agents for cost control.  
- Post monthly summary of queue health to leadership.  
- Link improvements to **Azure Boards** cost epic.

---

## 13. Extension & Marketplace Support for Azure DevOps

**Description**  
Handle extension install failures, permission prompts, task version pinning, and security review follow-ups for marketplace items.

**Skills**  
Extensions → Manage, task version syntax (`task: PublishBuildArtifacts@2`), OAuth scopes, org-level extension policies, allow/deny lists.

**Roles**  
Azure DevOps org admin, security engineer.

**Responsibilities**  
- Approve or deny extension requests per governance.  
- Troubleshoot tasks failing after extension auto-update.  
- Pin task versions in YAML for stability.  
- Remove unused extensions to reduce attack surface.  
- Document approved extension catalog in **Azure Wiki**.  
- Coordinate with vendors for enterprise support tickets.  
- Review OAuth scopes before approving OAuth extensions.  
- Track renewals for paid extensions.

---

## 14. Azure DevOps Audit & Compliance Evidence Support

**Description**  
Fulfill internal audit requests: export permission reports, pipeline run histories, and **Azure DevOps** audit events with redaction standards.

**Skills**  
Audit logs UI / REST, **Azure Boards** queries for change records, pipeline run retention, **Azure DevOps** permissions to export data, Excel/Power Query basics.

**Roles**  
Compliance analyst, Azure DevOps Administrator, security.

**Responsibilities**  
- Scope evidence request to date range and projects.  
- Export audit logs without exposing unrelated PII.  
- Provide list of org owners and project admins on demand.  
- Show branch policy coverage metrics for key repos.  
- Attach pipeline approval history screenshots or JSON exports.  
- Store evidence packages in approved secure location—not email.  
- Log each audit fulfillment in **Azure Boards** task.  
- Suggest automations to reduce manual repeats.

---

## 15. Azure DevOps Service Hooks & Integrations Break-Fix

**Description**  
Restore broken **service hooks** to Teams, Slack, Jenkins, or custom URLs; debug authentication and payload issues.

**Skills**  
Service hooks UI, secret rotation for shared secrets, JSON payloads, delivery history, firewall egress from Azure DevOps.

**Roles**  
Azure DevOps support engineer, collaboration admin.

**Responsibilities**  
- Re-send test payloads and verify HTTP response codes.  
- Update expired secrets on receiving side.  
- Remove duplicate hooks firing same channel twice.  
- Document owner and purpose per hook in **Azure Wiki**.  
- Coordinate with network team if IP allowlisting required.  
- Map hook failures to pipeline or work item impact.  
- Escalate product bugs for repeated 500s from service.  
- Track remediation in **Azure Boards**.

---

## 16. Azure DevOps New Project / Team Onboarding Support

**Description**  
Create **Azure DevOps** projects, default repos, sample `azure-pipelines.yml`, **Boards** area paths, and **Wiki** landing pages for new products.

**Skills**  
Project creation, repo initialization, branch policies setup wizard, environment skeleton, **Azure AD** group linking, naming standards.

**Roles**  
Azure DevOps Administrator, platform engineer, product lead.

**Responsibilities**  
- Apply standard process template and team structure.  
- Create empty YAML pipeline connected to repo.  
- Grant team groups Contributor + Build permissions appropriately.  
- Add sample **Boards** backlog and first sprint.  
- Publish onboarding checklist in **Azure Wiki**.  
- Schedule follow-up office hours after week one.  
- Verify billing/parallelism adequate for expected CI load.  
- Capture feedback for template improvements.

---

## 17. Azure DevOps PAT & Sign-In Support (Developer Desk)

**Description**  
Guide users through **Azure AD** sign-in issues, conditional access prompts, and PAT creation (only when no better option) for Git or tooling.

**Skills**  
Azure AD sign-in logs (if accessible), MFA policies, Git credential manager, PAT scopes minimalism, SSH key setup for **Azure Repos**.

**Roles**  
Help desk, Azure DevOps support engineer, identity admin.

**Responsibilities**  
- Prefer Git Credential Manager and SSO over long-lived PATs.  
- Teach SSH key upload for **Azure Repos** where appropriate.  
- Escalate conditional access blocks with correlation ID.  
- Revoke leaked PATs immediately via admin UI if reported.  
- Document supported client versions for Git integration.  
- Differentiate org URL typos (`dev.azure.com/org/project`).  
- Reset bad cached credentials instructions per OS.  
- Log repeated patterns for policy improvement.

---

## 18. Azure Pipelines Environment Approval & Deployment Freeze Support

**Description**  
Support release managers during freezes: pausing approvals, clarifying **Environment** deployment history, and recovering stuck deployments.

**Skills**  
Environments UI, approval policies, deployment jobs, checks, resource locks, manual validations, pipeline rerun from failed stage.

**Roles**  
Release manager, Azure DevOps support engineer, on-call dev.

**Responsibilities**  
- Identify pending approvals and notify correct approver groups.  
- Explain difference between redeploy whole pipeline vs single stage.  
- Clear erroneous checks after infra fix with audit note.  
- Document holiday freeze procedure in **Azure Wiki**.  
- Coordinate with teams when shared environment is locked.  
- Capture lessons when approvals bottleneck releases.  
- Suggest splitting environments per microservice if contention high.  
- Track incidents in **Azure Boards**.

---

## 19. Azure DevOps + Microsoft Teams / Slack Collaboration Support

**Description**  
Maintain **Azure Pipelines** / **Azure Boards** connectors: channel configuration, notification noise tuning, and troubleshooting missed alerts.

**Skills**  
Teams connector for Azure DevOps, Slack app configuration, subscription filters, `@mentions` in **Azure Boards** discussions.

**Roles**  
Collaboration admin, Scrum Master, Azure DevOps support engineer.

**Responsibilities**  
- Create channel subscriptions scoped to project or pipeline.  
- Reduce noise by filtering to failed production stages only.  
- Fix OAuth reconnect prompts after password changes.  
- Document which channel owns which service’s alerts.  
- Remove orphaned subscriptions when teams disband.  
- Align with incident comms for major outages.  
- Test mobile notifications for approvers.  
- Update **Azure Wiki** when vendor changes connector UX.

---

## 20. Azure DevOps Search, Wikis, and Work Item Performance Support

**Description**  
Address slow **Azure DevOps** search, timeouts in large queries, and guidance on indexing delays after bulk imports.

**Skills**  
Work item search vs query, query limits, folder structure for repos, code search scopes, performance best practices (narrow fields).

**Roles**  
Azure DevOps support engineer, PMO, repo admin.

**Responsibilities**  
- Rewrite expensive WIQL to filter early by area/iteration.  
- Explain eventual consistency after major migrations.  
- Split monolithic repos if search and PR performance suffer (advisory).  
- Clear user expectations on cross-project search permissions.  
- Escalate persistent slowness to Microsoft with traces.  
- Document recommended query patterns in **Azure Wiki**.  
- Train users on `@mention` and `#` linking features.  
- Track UX pain as feedback items.

---

## 21. Azure DevOps Backup of YAML & Critical Config (Operational Support)

**Description**  
Operational discipline: ensure pipeline definitions are only in **Azure Repos**, export critical **Azure Boards** process docs, and verify deleted-item recovery understanding.

**Skills**  
Git as source of truth, **Azure Repos** recycle bin, **Azure DevOps Server** backup (if on-prem), **az devops** scripts, Wiki export.

**Roles**  
Azure DevOps Administrator, SRE.

**Responsibilities**  
- Quarterly audit for classic pipelines still authoring in UI only.  
- Confirm default branch policies protect `main` pipeline YAML.  
- Document how to restore deleted repo within retention window.  
- Export process PDFs / wiki snapshots for compliance vault.  
- Test one restore drill per year and record outcomes.  
- Align with Microsoft shared responsibility for SaaS data.  
- Update **Azure Wiki** DR page when org structure changes.  
- Log drill tasks in **Azure Boards**.

---

## 22. Azure DevOps Guest / External Collaborator Support

**Description**  
Onboard vendors and consultants with **Azure AD B2B** guests into **Azure DevOps** projects with minimal access and expiry reviews.

**Skills**  
Guest invitations, **Azure AD** access reviews, project-level permissions, **Azure Repos** read vs contribute, pipeline visibility restrictions.

**Roles**  
Security engineer, Azure DevOps Administrator, vendor manager.

**Responsibilities**  
- Grant guests access only to required projects/repos.  
- Disable broader org-wide permissions for guests by default.  
- Use **Azure AD** access reviews on guest membership quarterly.  
- Document NDAs and data handling in vendor folder in **Azure Wiki**.  
- Remove guest access same day contract ends.  
- Monitor guest activity in audit logs for anomalies.  
- Explain sign-in experience differences for external tenants.  
- Track active guests list in **Azure Boards** or secure spreadsheet.

---

## 23. Azure DevOps Pipeline Retention & Artifact Cleanup Support

**Description**  
Help teams manage storage costs: pipeline retention rules, large **PublishPipelineArtifact** usage, and **Azure Artifacts** versions cleanup.

**Skills**  
Retention settings (project/org), pipeline artifact retention, **Azure Artifacts** retention policies, storage reporting.

**Roles**  
Azure DevOps org admin, FinOps, team leads.

**Responsibilities**  
- Identify pipelines producing multi-GB artifacts unnecessarily.  
- Recommend shorter retention for PR builds vs main branch.  
- Configure legal holds exceptions where audits require longer retention.  
- Purge old universal packages per policy.  
- Document which artifacts must never be deleted (compliance).  
- Educate on **DownloadPipelineArtifact@2** vs redundant copies.  
- Raise engineering standards for build outputs size.  
- Track savings after cleanup in **Azure Boards** cost story.

---

## 24. Azure DevOps Multi-Repo Checkout & Submodule Support

**Description**  
Debug failures involving `checkout: self` plus multiple `resources.repositories` or Git submodules in **Azure Pipelines**.

**Skills**  
Multi-repo checkout YAML, submodule auth (PAT/Credential Manager), shallow fetch options, path permissions, SSH vs HTTPS.

**Roles**  
Azure DevOps support engineer, build owner.

**Responsibilities**  
- Validate all repositories have **Azure Pipelines** app authorized or PAT scoped correctly.  
- Fix submodule URL formats for **Azure Repos**.  
- Tune `fetchDepth` for performance vs history needs.  
- Explain working directory layout for multi-checkout.  
- Document template repo consumption patterns in **Azure Wiki**.  
- Identify circular dependency between pipeline repos.  
- Escalate product issues with minimal reproduction YAML.  
- Log fixes as **Azure Boards** tasks for similar teams.

---

## 25. Azure DevOps Localization, Time Zone & Sprint Date Support

**Description**  
Resolve confusion from UTC vs local time in **Azure Pipelines** schedules, **Azure Boards** sprint dates, and global team iteration alignment.

**Skills**  
CRON schedules in YAML (`schedules`), project time zone settings, iteration date math, holiday calendars in **Azure Wiki**.

**Roles**  
Scrum Master, Azure DevOps support engineer, international team leads.

**Responsibilities**  
- Convert user-local desired schedule to correct UTC CRON.  
- Align iteration start/end to business calendar across regions.  
- Document daylight-saving pitfalls for scheduled pipelines.  
- Adjust **Boards** team settings when teams span zones.  
- Communicate maintenance windows in multiple time zones.  
- Validate scheduled pipeline last/next run timestamps with users.  
- Publish shared holiday calendar and link from **Azure Wiki**.  
- Track recurring confusion as doc improvement work item.

---

## 26. Azure DevOps Runbook Support for Azure Deployment Failures

**Description**  
Maintain **Azure Wiki** runbooks for common Azure deployment task failures from **Azure Pipelines** (`AzureWebApp@1`, ARM deployment, `AzureCLI@2`).

**Skills**  
ARM/Bicep error codes, App Service deployment logs, `AzureCLI@2` auth, resource locks, `AuthorizationFailed` RBAC diagnosis.

**Roles**  
SRE, Azure DevOps support engineer, cloud engineer.

**Responsibilities**  
- Keep runbook steps matched to current Azure portal blade names.  
- Add new error signatures after each major incident.  
- Link runbooks from **Azure Boards** incident work items.  
- Train on-call to start from pipeline log → Azure activity log.  
- Differentiate transient Azure outages vs permanent misconfig.  
- Schedule quarterly runbook tabletop exercises.  
- Prune obsolete steps after service UI changes.  
- Capture screenshots sparingly (prefer CLI commands).

---

## 27. Azure DevOps Training Office Hours & Office Documentation

**Description**  
Recurring open sessions for **Azure Repos**, **Pipelines**, **Boards**, and **Artifacts** questions; convert repeats into short **Azure Wiki** articles.

**Skills**  
Live demo of PR workflow, pipeline trace, Boards drag-drop, **Azure Test Plans** basics, screen recording tools.

**Roles**  
Platform champion, Azure DevOps Engineer, community of practice lead.

**Responsibilities**  
- Publish calendar invite and agenda topics weekly.  
- Record sessions (if policy allows) to internal stream.  
- Maintain FAQ page ranked by frequency.  
- Pair with new hires in first sprint onboarding.  
- Collect anonymous feedback after each session.  
- Propose template or policy changes from themes.  
- Measure attendance and unanswered question backlog.  
- Link **Azure Boards** improvement items from feedback.

---

## 28. Azure DevOps Cross-Project Dependency & Permission Support

**Description**  
Unblock scenarios where **Azure Pipelines** in project A must access **Azure Repos** or **feeds** in project B; configure permissions and `resources` correctly.

**Skills**  
Cross-project repo resources, feed sharing settings, pipeline OAuth scopes, **Azure DevOps** “Authorize resources” UI, multi-project governance.

**Roles**  
Azure DevOps Administrator, platform engineer, team leads.

**Responsibilities**  
- Enable explicit resource authorization rather than over-broad org rights.  
- Document approved cross-project patterns (templates vs repos).  
- Review security implications of shared feeds across business units.  
- Use **Azure Boards** to track each cross-project exception.  
- Prefer template repo in shared project over duplicating YAML.  
- Validate builds after permission changes with test pipeline.  
- Communicate changes to both project owners.  
- Periodically recertify still-needed cross-links.

---

## 29. Azure DevOps Support Metrics & Continuous Improvement

**Description**  
Run the support function like a product: track ticket volume, first response time, recurring themes, and drive **Azure Boards** backlog of platform fixes.

**Skills**  
**Azure Boards** queries for support work item tags, Power BI or Excel charts, retrospective facilitation, Kaizen mindset.

**Roles**  
Support lead, Azure DevOps CoE lead, engineering manager.

**Responsibilities**  
- Tag support tickets consistently (e.g., `ado-support`, area).  
- Publish monthly metrics dashboard to stakeholders.  
- Hold monthly retro on top pain points.  
- Promote automation candidates (wiki self-service, templates).  
- Celebrate reduced MTTR after major fixes.  
- Align support staffing with release calendars.  
- Ensure on-call for Azure DevOps platform is defined.  
- Close the loop when product fixes ship from Microsoft.

---

## 30. Azure DevOps Security Incident Support (Token Leak / Repo Exposure)

**Description**  
Respond to suspected credential leak in **Azure Repos**, overly permissive repo settings, or pipeline printing secrets in logs.

**Skills**  
Secret scanning (Defender for DevOps / third-party), PAT revocation, pipeline log scrubbing, **Azure Repos** permissions audit, **Azure AD** sign-in review.

**Roles**  
Security engineer, Azure DevOps org admin, incident commander.

**Responsibilities**  
- Immediately revoke compromised PATs and rotate service principal secrets.  
- Disable pipeline runs that echo secrets; fix YAML logging.  
- Tighten repo visibility from public to private if misconfigured.  
- Preserve audit logs before attacker deletion if threat scenario.  
- Open **Azure Boards** incident and link all actions taken.  
- Coordinate comms per legal/public relations guidance.  
- Post-incident: enable additional branch policies and scanning.  
- Train teams on **Azure Pipelines** secret variables and `isSecret` behavior.

---

*All support scenarios assume **Azure DevOps** (cloud or **Azure DevOps Server**) as the primary ALM and CI/CD platform.*
