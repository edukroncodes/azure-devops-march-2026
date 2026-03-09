# Azure DevOps Full Course Learning Plan (70 Hours, Hour-by-Hour)

This plan is a **complete learning path (70 hours)** covering **Azure DevOps**, core DevOps tooling, **DevSecOps**, **MLOps**, and **LLMOps** on Azure, with hands-on labs and a capstone project.

## Target Outcomes (What you’ll be able to do)
- **Plan and track work** using Azure Boards (Agile/Scrum/Kanban).
- **Manage code** using Git + Azure Repos with branch strategies, PRs, and policies.
- **Build CI/CD** using Azure Pipelines (YAML multi-stage, variables, approvals, artifacts, environments).
- **Containerize and deploy** apps with Docker + Kubernetes (AKS concepts) + Helm basics.
- **Provision infra** with Terraform on Azure using state, modules, and remote backend.
- **Secure delivery** with DevSecOps practices (secrets, scanning, SBOM concepts, gated pipelines).
- **Operate and observe** with Azure Monitor, Log Analytics, alerts, pipeline monitoring.
- **Run ML systems** with MLOps practices (data/versioning, training pipelines, registry, deployment, monitoring).
- **Ship LLM apps** with LLMOps practices (prompt/versioning, evals, safety, RAG, Azure OpenAI deployment and monitoring).

## Prerequisites
- Basic programming familiarity (any language) and basic web concepts.
- A Microsoft Azure account (free tier is fine) and access to an Azure DevOps organization.

## Tooling You’ll Use
- **Azure DevOps** (Boards, Repos, Pipelines, Artifacts)
- **Git** (local), **GitHub/GitLab** (optional for comparison), Azure Repos
- **Linux shell** (WSL recommended on Windows)
- **Docker** and **Kubernetes** (local K8s or managed concepts)
- **Terraform** + Azure Provider
- **Security** tools (conceptual + commonly used options in pipelines)
- **Azure Monitor / App Insights / Log Analytics**
- **Azure ML / MLflow concepts** (or equivalent) + **Azure OpenAI concepts**

---

## Module-wise Syllabus (with Hour Allocation)

### Module 1: DevOps Fundamentals (4 hours)
- Introduction to DevOps
- Traditional Software Development vs DevOps
- DevOps Lifecycle
- DevOps Principles and Culture
- Agile and Scrum Basics
- CI vs CD vs Continuous Deployment
- DevOps Toolchain Overview

### Module 2: Linux for DevOps (4 hours)
- Linux Basics, filesystem, permissions
- Core commands, package management
- Process management, networking commands
- Shell scripting basics (variables, loops, functions)

### Module 3: Git and Version Control (5 hours)
- Version control concepts; centralized vs distributed
- Git install/setup; repo creation; clone/pull/push
- Branching, merge vs rebase, conflicts
- Tags, hooks (what/why), GitHub/GitLab integration overview

### Module 4: Azure Fundamentals (5 hours)
- Cloud computing basics; Azure overview
- Regions, availability, global infrastructure
- Azure Resource Manager (ARM) concepts
- VMs, storage, networking basics
- Identity and access management basics

### Module 5: Azure DevOps Introduction (2 hours)
- Azure DevOps architecture and services
- Orgs, projects, repos overview
- Access management, user roles and permissions

### Module 6: Azure Boards (3 hours)
- Agile project management in ADO
- Work item types: epics/features/stories/tasks/bugs
- Backlogs, sprint planning
- Kanban boards, queries
- Dashboards and reports

### Module 7: Azure Repos (2 hours)
- Git repos in Azure DevOps
- Branching strategies (trunk-based vs GitFlow)
- Pull requests, code reviews, branch policies
- Repo permissions

### Module 8: Azure Pipelines (9 hours)
- CI/CD concepts and patterns
- Build pipelines, YAML pipelines
- Stages/jobs/tasks; agents (Microsoft-hosted vs self-hosted)
- Variables, variable groups, environments
- Triggers, artifact publishing
- Multi-stage pipelines and release strategies

### Module 9: Docker (4 hours)
- Containers vs VMs; Docker architecture
- Images/containers; Dockerfile; build/run
- Registry (Docker Hub / ACR concepts)
- Networking, volumes; Docker Compose basics

### Module 10: Kubernetes (7 hours)
- K8s architecture and components
- Pods, ReplicaSets, Deployments
- Services, ConfigMaps, Secrets, Volumes
- Networking basics, rolling updates, scaling
- Dashboard concepts; Helm basics

### Module 11: Terraform (6 hours)
- IaC concepts; Terraform architecture
- Providers, configuration files, core commands
- State, variables, modules
- Remote backend, workspaces
- Terraform with Azure (design + practice)

### Module 12: Azure Artifacts (2 hours)
- Package management concepts
- Feeds, versioning
- Publish/consume packages
- Integrate artifacts with pipelines

### Module 13: Monitoring and Logging (3 hours)
- Monitoring in DevOps
- Azure Monitor, Application Insights
- Log Analytics, alerts/notifications
- Pipeline monitoring basics

### Module 14: DevSecOps (4 hours)
- DevSecOps intro and security in CI/CD
- Secret management + Azure Key Vault
- Secure pipeline practices (permissions, approvals, least privilege)
- Code quality and scanning integration concepts (e.g., SonarQube, SAST/SCA, container scanning)

### Module 15: Real-Time DevOps Project (4 hours)
End-to-end implementation:
- Create repo, push code
- Build pipeline (CI)
- Build/push Docker image to registry
- Provision infra with Terraform
- Deploy to Kubernetes
- Configure CD + approvals
- Set up monitoring and alerts

### Module 16: MLOps on Azure (4 hours)
- MLOps lifecycle: data → training → registry → deployment → monitoring
- Experiment tracking (MLflow concepts), model registry
- Training pipelines and reproducibility
- CI/CD for ML (unit tests, data checks, model validation gates)
- Drift/quality monitoring concepts

### Module 17: LLMOps on Azure (2 hours)
- LLM app lifecycle: prompts → evals → safety → deployment → monitoring
- Prompt/versioning; offline and online evaluation concepts
- RAG fundamentals (indexing, retrieval, grounding)
- Safety, policies, PII considerations, and guardrails concepts
- Deploy/observe LLM apps (Azure OpenAI concepts + telemetry)

---

## Hour-by-Hour Learning Path (70 Hours Total)
**Format:** Each hour includes a learning focus + a practical task (lab/output).

### Module 1 (M1): DevOps Fundamentals (Hours 1–4)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 1 | DevOps overview + why DevOps | 1) DevOps definition<br>2) Business outcomes (speed, quality)<br>3) Lead time basics<br>4) Deployment frequency basics<br>5) Change failure rate basics<br>6) MTTR basics<br>7) Feedback loops<br>8) Automation mindset<br>9) Collaboration model<br>10) Value stream overview | Map DevOps lifecycle to a sample app |
| 2 | Dev vs DevOps + CALMS culture | 1) Silos and handoffs<br>2) Bottlenecks and queues<br>3) CALMS: Culture<br>4) CALMS: Automation<br>5) CALMS: Lean<br>6) CALMS: Measurement<br>7) CALMS: Sharing<br>8) Ownership and accountability<br>9) Blameless postmortems<br>10) Continuous improvement loop | Identify bottlenecks in a “traditional” flow |
| 3 | CI/CD/CT (concepts) | 1) CI definition and goals<br>2) Build vs test stages<br>3) Artifact concept<br>4) CD (delivery) definition<br>5) CD (deployment) definition<br>6) Trunk-based CI habits<br>7) Feature flags concept<br>8) Rollback vs roll-forward<br>9) Environment promotion model<br>10) Release management vocabulary | Draw CI vs CD vs deployment pipeline diagram |
| 4 | Agile/Scrum + toolchain overview | 1) Agile principles summary<br>2) Scrum roles<br>3) Scrum ceremonies<br>4) Sprint backlog vs product backlog<br>5) Definition of Done<br>6) Estimation basics (story points)<br>7) Kanban WIP limits<br>8) DevOps toolchain map (plan-code-build-test-release-operate-monitor)<br>9) Common tool categories (SCM, CI, IaC, observability)<br>10) Choosing tools by constraints | Create a minimal toolchain checklist |

### Module 2 (M2): Linux for DevOps (Hours 5–8)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 5 | Linux basics + filesystem | 1) Linux distributions overview<br>2) Shell vs terminal<br>3) Paths (absolute vs relative)<br>4) File types and extensions reality<br>5) Directory navigation commands<br>6) Listing and searching basics<br>7) Viewing file contents safely<br>8) Editing basics (choose editor)<br>9) Environment variables intro<br>10) Exit codes basics | Navigate directories; create files/folders |
| 6 | Permissions + users/groups | 1) Users vs groups model<br>2) Permission bits (rwx)<br>3) Numeric modes (e.g., 755)<br>4) Ownership (user:group)<br>5) umask concept<br>6) chmod/chown/chgrp usage<br>7) Executable bit meaning<br>8) SUID/SGID concept<br>9) Sticky bit concept<br>10) Least privilege on servers | Practice chmod/chown; explain rwx numerically |
| 7 | Processes + services | 1) Process vs thread concept<br>2) Foreground vs background<br>3) ps/top/htop usage<br>4) Signals (TERM vs KILL)<br>5) systemd basics (service units)<br>6) Logs basics (journal)<br>7) Ports and listeners concept<br>8) Resource limits concept<br>9) Scheduling basics (cron concept)<br>10) Debug mindset for hung processes | Use ps/top/kill; manage a background process |
| 8 | Networking + shell scripting intro | 1) IP and DNS basics<br>2) ping vs curl vs wget purpose<br>3) traceroute concept<br>4) netstat/ss concept<br>5) Firewall concept<br>6) Bash variables and quoting<br>7) Conditionals (if) basics<br>8) Loops (for/while) basics<br>9) Functions basics<br>10) Script exit codes and set -e concept | Write a tiny script (args + loop) |

### Module 3 (M3): Git and Version Control (Hours 9–13)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 9 | Version control fundamentals | 1) Why version control exists<br>2) Repository concept<br>3) Commit concept<br>4) Diff concept<br>5) Branch concept<br>6) Tag concept<br>7) Working tree vs staging area<br>8) History as audit trail<br>9) Code review value<br>10) Semantic versioning concept | Write a commit message rubric for yourself |
| 10 | Git setup + local repo | 1) Install Git and verify<br>2) Configure user name/email<br>3) Create a repository<br>4) .gitignore basics<br>5) Add and commit flow<br>6) Inspect history (log)<br>7) Compare changes (diff)<br>8) Amend vs new commit (concept)<br>9) Reset vs revert (concept)<br>10) Repo hygiene (small commits) | Init repo; configure identity; first commits |
| 11 | Clone/pull/push + remotes | 1) Remote concept (origin)<br>2) Clone vs init<br>3) Fetch vs pull<br>4) Push basics<br>5) Upstream tracking branches<br>6) Authentication (PAT/SSH concept)<br>7) Handling divergence concept<br>8) Pull strategies (merge vs rebase)<br>9) Remote branches listing<br>10) Safe collaboration rules | Connect remote; push branch; fetch changes |
| 12 | Branching strategies | 1) Trunk-based development overview<br>2) Short-lived branches<br>3) GitFlow overview<br>4) Release branches purpose<br>5) Hotfix handling<br>6) Branch naming conventions<br>7) PR-based workflow<br>8) Merge methods (merge commit, squash, rebase)<br>9) Protecting `main` concept<br>10) Strategy selection criteria | Create branches; compare trunk vs GitFlow |
| 13 | Merge/rebase + conflicts | 1) Merge mechanics<br>2) Rebase mechanics<br>3) When to rebase safely<br>4) Conflict markers and meaning<br>5) Resolving conflicts systematically<br>6) Three-way merge concept<br>7) Binary conflicts concept<br>8) Avoiding conflicts with smaller PRs<br>9) Using blame/history to decide<br>10) Post-merge cleanup (delete branches) | Resolve a merge conflict deliberately |

### Module 4 (M4): Azure Fundamentals (Hours 14–18)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 14 | Cloud concepts + Azure overview | 1) IaaS vs PaaS vs SaaS<br>2) Shared responsibility model<br>3) Subscription concept<br>4) Resource group concept<br>5) Azure portal vs CLI concept<br>6) Cost management basics<br>7) Service limits and quotas<br>8) Network security basics (NSG concept)<br>9) Logging/monitoring basics in cloud<br>10) Landing zone idea (high-level) | List core Azure services used in DevOps |
| 15 | Azure global infra | 1) Regions vs geographies<br>2) Availability zones concept<br>3) Paired regions concept<br>4) Latency considerations<br>5) Data residency/compliance basics<br>6) Multi-region DR concept<br>7) Failover patterns overview<br>8) Service availability differences<br>9) Choosing region for pipelines/agents<br>10) Cost vs performance trade-offs | Choose region strategy (latency/compliance) |
| 16 | ARM basics + resource groups | 1) ARM control plane concept<br>2) Resource provider concept<br>3) Resource group lifecycle<br>4) Tags strategy<br>5) RBAC at scope levels<br>6) Policy concept (guardrails)<br>7) Blueprints concept (high-level)<br>8) Naming conventions strategy<br>9) Environment separation model<br>10) Idempotency concept | Sketch RG layout for dev/test/prod |
| 17 | Compute + networking (VM/VNet) | 1) VNet concept<br>2) Subnets and CIDR basics<br>3) NSG rules concept<br>4) Public IP vs private IP<br>5) NAT and outbound rules concept<br>6) DNS basics in Azure<br>7) VM sizing basics<br>8) Managed identity concept<br>9) Bastion/jumpbox concept<br>10) Network troubleshooting signals | Design a basic VNet/subnet diagram |
| 18 | Storage + IAM basics | 1) Storage account concept<br>2) Blob vs file vs queue vs table<br>3) Redundancy options concept (LRS/ZRS/GRS)<br>4) Access keys vs SAS vs RBAC<br>5) Managed identities usage concept<br>6) Azure AD vs local identities<br>7) Service principals concept<br>8) Role assignments basics<br>9) Key Vault vs storage secrets concept<br>10) Audit and access review concept | Define storage types + RBAC examples |

### Module 5 (M5): Azure DevOps Introduction (Hours 19–20)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 19 | Azure DevOps: orgs/projects/services | 1) Organization structure<br>2) Projects vs teams concept<br>3) ADO service map (Boards, Repos, Pipelines, Artifacts)<br>4) Project settings overview<br>5) Process templates concept (Agile/Scrum/CMMI)<br>6) Service connections concept<br>7) Agent pools overview<br>8) Permissions model high-level<br>9) Work item customization concept<br>10) Governance baseline checklist | Create/inspect project structure (conceptual) |
| 20 | Permissions + access management | 1) Users vs groups in ADO<br>2) Project-level roles<br>3) Repo permissions concepts<br>4) Pipeline permissions concepts<br>5) Environment permissions concepts<br>6) Service connection security concept<br>7) Least privilege patterns<br>8) Audit trail expectations<br>9) Approvals and checks concept<br>10) Access review routine | Define roles; least privilege checklist |

### Module 6 (M6): Azure Boards (Hours 21–23)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 21 | Boards: work item types | 1) Epics vs features vs stories<br>2) Tasks vs bugs<br>3) Acceptance criteria writing<br>4) INVEST principles for stories<br>5) Estimation and sizing<br>6) Priority and ordering<br>7) Definition of Ready concept<br>8) Linking work items to commits/PRs<br>9) Iterations and area paths<br>10) Work item state workflows | Create epics/features/stories/tasks mapping |
| 22 | Backlogs + sprint planning | 1) Backlog grooming concept<br>2) Sprint goal definition<br>3) Capacity planning basics<br>4) Planning poker concept<br>5) Splitting stories techniques<br>6) Managing dependencies concept<br>7) Sprint board usage<br>8) Daily standup signals<br>9) Sprint review outcomes<br>10) Retrospective action items | Plan a 1-week sprint for a demo app |
| 23 | Kanban + queries/dashboards | 1) Kanban columns design<br>2) WIP limits concept<br>3) Lead time vs cycle time<br>4) Cumulative flow concept<br>5) Blockers and policies<br>6) Queries basics (filters, fields)<br>7) Query charts concept<br>8) Dashboards composition<br>9) Widgets selection criteria<br>10) Reporting anti-patterns | Build a query + dashboard mock layout |

### Module 7 (M7): Azure Repos (Hours 24–25)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 24 | Repos in ADO + policies | 1) Repo structure conventions<br>2) Default branch settings<br>3) Branch policies overview<br>4) Required reviewers concept<br>5) Build validation policy concept<br>6) Minimum reviewers and code owners concept<br>7) Comment resolution and threads<br>8) Merge types selection<br>9) Signed commits concept (high-level)<br>10) Protecting secrets in repos | Define branch policies for `main` |
| 25 | PRs + code review workflow | 1) PR description quality checklist<br>2) Small PR sizing targets<br>3) Review priorities (correctness, security, performance)<br>4) Review etiquette and tone<br>5) Handling review feedback<br>6) Linking PRs to work items<br>7) CI checks required before merge<br>8) Changelog/release notes concept<br>9) Post-merge cleanup<br>10) Common review red flags | Create PR checklist (tests, security, docs) |

### Module 8 (M8): Azure Pipelines (Hours 26–34)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 26 | Pipelines intro + agents | 1) Pipeline vs build vs release terminology<br>2) Azure Pipelines YAML vs classic overview<br>3) Agent pools concept<br>4) Hosted agents pros/cons<br>5) Self-hosted agents pros/cons<br>6) Tooling on agents (SDKs)<br>7) Permissions to run pipelines<br>8) Service connections basics<br>9) Artifact storage options concept<br>10) Pipeline cost and concurrency | Pick hosted vs self-hosted decision matrix |
| 27 | YAML pipeline structure | 1) YAML schema basics<br>2) stages/jobs/steps structure<br>3) Checkout step behavior<br>4) Script vs task steps<br>5) Build numbering concept<br>6) Caching concept (dependencies)<br>7) Publishing test results concept<br>8) Pipeline variables basics<br>9) Conditions concept<br>10) Failure handling basics | Write a minimal YAML (build + test) |
| 28 | Triggers + variables | 1) CI triggers (branch filters)<br>2) PR triggers basics<br>3) Path filters concept<br>4) Scheduled triggers concept<br>5) Variable scopes (pipeline, stage, job)<br>6) Secret variables concept<br>7) Variable groups concept<br>8) Runtime parameters concept<br>9) Environment variables mapping<br>10) Avoiding secret leakage in logs | Add triggers; use variables and secrets pattern |
| 29 | Artifacts + publishing | 1) Artifact types (pipeline, build, package) concept<br>2) When to publish artifacts<br>3) Folder structure for outputs<br>4) Naming conventions for artifacts<br>5) Versioning strategy overview<br>6) Immutable artifacts principle<br>7) Storing manifests and SBOM concept<br>8) Retention policies concept<br>9) Promoting artifacts vs rebuilding<br>10) Traceability to commit/work item | Publish build artifact; name/version strategy |
| 30 | Multi-stage pipelines | 1) Stage separation rationale<br>2) Build stage design<br>3) Test stage design<br>4) Security scan stage concept<br>5) Deploy stage concept<br>6) Stage dependencies (dependsOn)<br>7) Approvals and checks concept<br>8) Using environments for deployments<br>9) Cross-stage artifacts flow<br>10) Release notes automation concept | Add stages: build → test → package |
| 31 | Environments + approvals | 1) What environments represent in ADO<br>2) Environment permissions model<br>3) Manual approvals<br>4) Checks concept (quality gates)<br>5) Resource deployment targets concept<br>6) Deployment history tracking<br>7) Approver separation of duties concept<br>8) Emergency break-glass concept<br>9) Auditability requirements<br>10) Avoiding approval bottlenecks | Add environment gates/approvals conceptually |
| 32 | Deployment strategies | 1) Rolling deployments basics<br>2) Blue/green deployments basics<br>3) Canary deployments basics<br>4) Feature flags vs canary<br>5) Traffic shifting concept<br>6) Database migration strategy concept<br>7) Backward compatibility basics<br>8) Health checks and verification<br>9) Rollback criteria definition<br>10) Post-deploy monitoring window | Blue/green vs canary vs rolling comparison |
| 33 | Templates + reuse | 1) DRY principle in pipelines<br>2) YAML templates (stages/jobs/steps) concept<br>3) Parameterizing templates<br>4) Variable templates concept<br>5) Reusable scripts organization<br>6) Centralized vs per-repo templates trade-offs<br>7) Versioning pipeline templates<br>8) Security review for shared templates<br>9) Standardizing build/test tasks<br>10) Docs for pipeline consumers | Convert repeated YAML to templates approach |
| 34 | Troubleshooting pipelines | 1) Reading logs effectively<br>2) Common YAML mistakes<br>3) Agent capability mismatches<br>4) Path issues and working directory<br>5) Permission failures diagnosis<br>6) Service connection failures diagnosis<br>7) Flaky tests handling strategy<br>8) Artifact not found scenarios<br>9) Variable evaluation pitfalls<br>10) Rerun vs fix-forward discipline | Debug common failures (paths, agents, vars) |

### Module 9 (M9): Docker (Hours 35–38)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 35 | Docker basics + architecture | 1) Image vs container distinction<br>2) Layers and caching concept<br>3) Docker engine components<br>4) Container isolation basics<br>5) Namespaces/cgroups concept (high-level)<br>6) Docker CLI basics<br>7) Port mapping concept<br>8) Container logs basics<br>9) Cleaning unused images/containers safely<br>10) Security basics (least privilege in containers) | Install/verify Docker; run hello-world |
| 36 | Dockerfile + image build | 1) Base images selection<br>2) Multi-stage builds concept<br>3) Copy vs add differences concept<br>4) RUN vs CMD vs ENTRYPOINT<br>5) Working directory and user directives<br>6) Build args vs env vars<br>7) Minimizing image size basics<br>8) Reproducible builds concept<br>9) Tagging strategy basics<br>10) Container healthcheck concept | Build image for sample app |
| 37 | Registry + networking/volumes | 1) Registry concept and auth<br>2) Pull/push mechanics<br>3) Tags vs digests<br>4) Private vs public registries<br>5) Network modes concept<br>6) Bridge networking basics<br>7) DNS inside Docker networks concept<br>8) Volumes vs bind mounts<br>9) Persisting data correctly<br>10) Secrets/config in containers concept | Push/pull; use a volume; expose a port |
| 38 | Docker Compose | 1) Compose file structure<br>2) Services definition<br>3) Networks in Compose<br>4) Volumes in Compose<br>5) Environment injection<br>6) Depends_on behavior and caveats<br>7) Healthcheck usage concept<br>8) Local dev workflow patterns<br>9) Scaling services concept<br>10) Moving from Compose to Kubernetes mapping | Compose app + dependency (e.g., app + DB) |

### Module 10 (M10): Kubernetes (Hours 39–45)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 39 | K8s architecture | 1) Cluster concept<br>2) Control plane components overview<br>3) Node components overview<br>4) API server role<br>5) Scheduler role<br>6) etcd role concept<br>7) kubelet role<br>8) kube-proxy concept<br>9) CNI concept (network plugin)<br>10) RBAC concept in Kubernetes | Identify control plane vs node responsibilities |
| 40 | Pods/Deployments/ReplicaSets | 1) Pod definition basics<br>2) ReplicaSet purpose<br>3) Deployment controller purpose<br>4) Desired state model<br>5) Labels and selectors<br>6) Rolling update strategy basics<br>7) Pod lifecycle basics<br>8) Resource requests/limits concept<br>9) Scaling replicas vs autoscaling concept<br>10) Debugging pods (describe/logs) concept | Deploy app; scale replicas |
| 41 | Services + networking basics | 1) Service abstraction purpose<br>2) ClusterIP meaning<br>3) NodePort meaning<br>4) LoadBalancer meaning<br>5) Ingress concept overview<br>6) DNS service discovery concept<br>7) Port vs targetPort concept<br>8) Network policies concept (high-level)<br>9) TLS termination concept (high-level)<br>10) Common connectivity failures | Expose service; understand ClusterIP/LoadBalancer |
| 42 | ConfigMaps + Secrets | 1) Externalizing config rationale<br>2) ConfigMap from file/env concept<br>3) Mount ConfigMap as volume<br>4) Inject ConfigMap as env vars<br>5) Secret types concept (generic, tls)<br>6) Base64 encoding caveat<br>7) Secret management best practices (don’t commit)<br>8) Rotating secrets concept<br>9) Integrating with Key Vault concept<br>10) App configuration patterns | Externalize config; mount as env/volume |
| 43 | Volumes + persistence | 1) Ephemeral storage vs persistent<br>2) Volume types overview concept<br>3) PersistentVolume and PVC concept<br>4) Storage classes concept<br>5) Access modes concept<br>6) Stateful vs stateless apps<br>7) Backups and restore concept<br>8) Data migration concerns concept<br>9) Security of storage (encryption) concept<br>10) Debugging mount issues concept | Add persistent storage concept to workload |
| 44 | Rolling updates + probes | 1) Readiness probe purpose<br>2) Liveness probe purpose<br>3) Startup probe concept<br>4) Graceful shutdown concept<br>5) Deployment rollout status concept<br>6) Rollback mechanics concept<br>7) Surge and unavailable settings concept<br>8) Zero-downtime constraints<br>9) Verifying deployment with smoke tests concept<br>10) Observability during rollout | Configure readiness/liveness; rollout/rollback |
| 45 | Helm basics | 1) Helm chart structure<br>2) Values and templates concept<br>3) Releases concept<br>4) Upgrades and rollbacks concept<br>5) Chart repositories concept<br>6) Managing environments with values files<br>7) Secrets handling in Helm concept<br>8) Linting charts concept<br>9) Chart versioning strategy<br>10) Helm vs raw manifests trade-offs | Install a chart; override values for envs |

### Module 11 (M11): Terraform (Hours 46–51)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 46 | IaC basics + Terraform workflow | 1) Declarative vs imperative IaC<br>2) Terraform init/plan/apply lifecycle<br>3) Provider/plugin concept<br>4) Resource blocks concept<br>5) Dependency graph concept<br>6) Drift detection concept<br>7) Idempotency expectations<br>8) Formatting and validation commands concept<br>9) Sensitive values handling concept<br>10) Reviewing plans in PRs concept | Write first `main.tf`; plan/apply mentally |
| 47 | Providers + resources | 1) Azure provider authentication options concept<br>2) Resource group resource concept<br>3) Networking resources overview concept<br>4) Compute resources overview concept<br>5) Storage resources overview concept<br>6) Using data sources concept<br>7) Referencing attributes<br>8) Dependencies with depends_on concept<br>9) Import existing resources concept<br>10) Provider version pinning concept | Configure Azure provider; create core resources (concept) |
| 48 | Variables + outputs | 1) Input variables definition<br>2) Variable types (string, map, list)<br>3) Defaults and validation concept<br>4) tfvars files usage<br>5) Sensitive variables concept<br>6) Locals usage concept<br>7) Outputs purpose<br>8) Passing outputs to pipelines concept<br>9) Naming conventions for variables<br>10) Avoiding over-parameterization | Parameterize environment config |
| 49 | State + remote backend | 1) State file purpose<br>2) Risks of local state<br>3) Remote state benefits<br>4) State locking concept<br>5) State encryption concept<br>6) State separation per environment<br>7) Moving/renaming resources concept<br>8) State drift and reconciliation<br>9) Backups and recovery concept<br>10) Access control for state | Explain state risks; design remote state layout |
| 50 | Modules | 1) Module concept and benefits<br>2) Root vs child modules<br>3) Inputs/outputs design<br>4) Module boundaries (network, compute, app)<br>5) Versioning modules concept<br>6) Publishing modules concept<br>7) Avoiding circular dependencies<br>8) Testing modules concept (high-level)<br>9) Documentation for modules<br>10) Module reuse across environments | Create a reusable module boundary design |
| 51 | Workspaces + environment separation | 1) Workspace concept<br>2) When workspaces help<br>3) When separate state is better<br>4) Separate subscriptions concept<br>5) Separate repos vs mono-repo trade-offs<br>6) Promotion model (dev→test→prod)<br>7) Secrets per environment<br>8) Access boundaries per environment<br>9) Naming and tagging per environment<br>10) Disaster recovery for infra pipelines | Decide: workspaces vs separate states/repos |

### Module 12 (M12): Azure Artifacts (Hours 52–53)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 52 | Artifacts feeds + versioning | 1) What a package is<br>2) Feed purpose<br>3) Upstream sources concept<br>4) Permissions for feeds<br>5) Semantic versioning rules<br>6) Pre-release versions concept<br>7) Deprecation policy concept<br>8) Retention policies concept<br>9) Build metadata concept<br>10) Traceability from package to commit | Define package version rules (SemVer) |
| 53 | Consume artifacts in pipeline | 1) Restore dependencies step concept<br>2) Authenticate to feed concept<br>3) Lockfiles concept<br>4) Cache dependencies concept<br>5) Publish package step concept<br>6) Promote package to views concept<br>7) Vulnerable dependency scanning concept<br>8) License compliance concept<br>9) Reproducible builds with pinned deps<br>10) Handling breaking changes policy | Add restore/publish steps conceptually |

### Module 13 (M13): Monitoring and Logging (Hours 54–56)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 54 | Azure Monitor fundamentals | 1) Metrics vs logs vs traces<br>2) Golden signals (latency, traffic, errors, saturation)<br>3) SLI vs SLO vs SLA<br>4) Alert fatigue concept<br>5) Dashboard design basics<br>6) Action groups concept<br>7) Severity levels definition<br>8) Runbooks concept<br>9) On-call basics concept<br>10) Incident lifecycle basics | Define SLI/SLO basics for your app |
| 55 | App Insights + tracing | 1) Instrumentation concept<br>2) Request telemetry concept<br>3) Dependencies telemetry concept<br>4) Exceptions telemetry concept<br>5) Distributed tracing concept<br>6) Correlation IDs concept<br>7) Sampling concept<br>8) Custom events/metrics concept<br>9) Availability tests concept<br>10) Performance baselining concept | Identify key telemetry events for API |
| 56 | Log Analytics + alerts | 1) Workspace concept<br>2) KQL basics concept<br>3) Query patterns for errors<br>4) Query patterns for latency<br>5) Log ingestion costs concept<br>6) Alert rules from queries concept<br>7) Alert thresholds and windows<br>8) Suppression and deduplication concept<br>9) Escalation paths concept<br>10) Post-incident review inputs | Create alert rules plan (latency/errors) |

### Module 14 (M14): DevSecOps (Hours 57–60)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 57 | DevSecOps overview + threat thinking | 1) Shift-left security concept<br>2) Threat modeling basics<br>3) Attack surface in CI/CD<br>4) Supply chain security overview<br>5) Trust boundaries concept<br>6) Principle of least privilege in pipelines<br>7) Secure defaults concept<br>8) Logging/audit for security<br>9) Incident response basics<br>10) Security gates vs delivery speed trade-off | Create a mini threat model for pipeline |
| 58 | Secrets + Key Vault | 1) What qualifies as a secret<br>2) Secret sprawl risks<br>3) Key Vault purpose<br>4) Secrets vs keys vs certificates<br>5) Access policies/RBAC concept<br>6) Managed identity integration concept<br>7) Secret rotation strategy<br>8) Avoiding secrets in logs<br>9) Pipeline secret variables best practice<br>10) Runtime secret injection patterns | Define secret flow: dev → pipeline → runtime |
| 59 | Secure pipeline practices | 1) Protected branches and required checks<br>2) Required reviewers and code owners concept<br>3) Build validation policy and gating<br>4) Environment approvals and checks<br>5) Restricting service connections usage<br>6) Agent security (self-hosted hardening) concept<br>7) Artifact integrity concept (immutability)<br>8) Permissions for variable groups<br>9) Auditing changes to pipelines<br>10) Break-glass process definition | Add approvals, RBAC, protected branches checklist |
| 60 | Code quality + scanning integration | 1) Linting and formatting gates<br>2) Unit test gates<br>3) Coverage thresholds concept<br>4) SAST concept and placement in pipeline<br>5) SCA concept for dependencies<br>6) Container image scanning concept<br>7) IaC scanning concept<br>8) Secrets scanning concept<br>9) SBOM concept and usage<br>10) Fail vs warn policy tuning | Choose gates: tests + lint + SAST/SCA + container scan |

### Module 15 (M15): Real-Time DevOps Project (Hours 61–64)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 61 | Project setup: repo + boards + backlog | 1) Choose sample app scope<br>2) Repo layout (src, infra, pipelines)<br>3) Initialize Boards backlog<br>4) Define epics/features/stories<br>5) Add acceptance criteria for stories<br>6) Define Definition of Done<br>7) Create sprint and capacity<br>8) Link repos to boards practices<br>9) Establish branching strategy<br>10) Create initial PR policies | Create repo structure + initial work items |
| 62 | CI: build/test + artifacts | 1) Add build step<br>2) Add unit tests step<br>3) Add lint step<br>4) Add test results publishing<br>5) Add build caching concept<br>6) Generate build artifact<br>7) Artifact naming and versioning<br>8) PR validation pipeline configuration<br>9) Build badge/reporting concept<br>10) Fail-fast vs collect-all-results strategy | Implement CI stages plan; artifact naming |
| 63 | Containerize + push to registry | 1) Dockerfile finalization<br>2) Multi-stage build usage<br>3) Tagging strategy (commit SHA + semver)<br>4) Authenticate to registry concept<br>5) Build and push step in pipeline concept<br>6) Image provenance concept<br>7) Image scanning gate concept<br>8) Store image digest for traceability<br>9) Promotion strategy (dev vs prod tags)<br>10) Rollback by digest concept | Build/push image; tag strategy (commit SHA) |
| 64 | IaC + deploy to K8s | 1) Terraform plan for required resources<br>2) Remote state setup concept<br>3) Create Kubernetes manifests or Helm chart structure<br>4) Configure deployment values per env<br>5) Add pipeline deploy stage concept<br>6) Add environment approvals concept<br>7) Configure config/secrets injection concept<br>8) Add smoke tests post-deploy concept<br>9) Add rollback strategy concept<br>10) Document runbook for release | Terraform plan + K8s manifests/Helm plan |

### Module 16 (M16): MLOps on Azure (Hours 65–68)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 65 | MLOps lifecycle + artifacts | 1) Define ML problem and metric<br>2) Data sources and dataset definition<br>3) Data versioning concept<br>4) Feature engineering reproducibility concept<br>5) Training/validation split practices<br>6) Dataset quality checks concept<br>7) Model artifact packaging concept<br>8) Pipeline vs notebook separation concept<br>9) Governance and approvals concept<br>10) Traceability from model to data/code | Define dataset/model versioning approach |
| 66 | Experiment tracking + registry | 1) Experiment tracking purpose<br>2) Run metadata (params, metrics, artifacts)<br>3) Reproducibility fields checklist<br>4) Model registry purpose<br>5) Staging vs production model states concept<br>6) Model versioning strategy<br>7) Approval gates for models concept<br>8) Signing/provenance concept (high-level)<br>9) Packaging inference code and dependencies<br>10) Documentation for model cards concept | Decide tracking + registry workflow |
| 67 | Training pipeline + validation gates | 1) Automated training trigger patterns<br>2) Data validation gates concept<br>3) Feature drift checks concept<br>4) Model metric thresholds gates<br>5) Bias/fairness checks concept (high-level)<br>6) Unit tests for data/feature code concept<br>7) Reproducible environments concept (containers)<br>8) CI for ML code + pipeline definitions<br>9) Artifact retention for experiments<br>10) Roll-forward strategy for model updates | Add data checks + model metric thresholds |
| 68 | Deploy + monitor ML models | 1) Batch vs online inference<br>2) Endpoint deployment concepts<br>3) Canary for models concept<br>4) Shadow deployments concept<br>5) Monitoring latency and errors<br>6) Monitoring prediction quality signals<br>7) Concept drift vs data drift<br>8) Retraining triggers criteria<br>9) A/B testing concept<br>10) Incident response for ML services | Outline online/batch inference + drift monitoring |

### Module 17 (M17): LLMOps on Azure (Hours 69–70)
| Hour | Subsection (Focus) | subtopics | Hands-on / Output |
|---:|---|---|---|
| 69 | LLMOps: prompt/versioning + evals | 1) LLM app architecture overview<br>2) Prompt templates concept<br>3) Prompt versioning and change control<br>4) Offline eval datasets concept<br>5) Online eval signals concept<br>6) Quality metrics (accuracy, faithfulness) concept<br>7) Safety metrics (toxicity, jailbreak) concept<br>8) Latency and cost budgeting concept<br>9) Regression testing for prompts concept<br>10) Release gating using eval thresholds concept | Create eval checklist: accuracy, toxicity, latency |
| 70 | RAG + safety + monitoring | 1) RAG architecture (index-retrieve-generate)<br>2) Chunking strategies concept<br>3) Embeddings concept<br>4) Retrieval tuning (top-k, filters) concept<br>5) Grounding and citations concept<br>6) Hallucination mitigation tactics<br>7) PII handling strategy concept<br>8) Prompt injection threats concept<br>9) Telemetry for LLM apps (tokens, latency, refusals)<br>10) Post-deploy continuous evaluation loop | Design RAG flow + guardrails + telemetry plan |

---

## Capstone Project (Recommended Scope)
Build a small web API (any language) and deliver it end-to-end:
- **Planning**: Stories/tasks in Boards; sprint board and dashboard
- **Code**: Azure Repos with PR reviews + branch policies
- **CI**: Build + test + lint + publish artifact
- **Container**: Build and push Docker image to a registry (ACR or Docker Hub)
- **Infra**: Terraform module(s) to provision Azure resources (at least RG + networking + registry + K8s/AKS conceptually or alternative K8s target)
- **CD**: Multi-stage YAML pipeline to deploy to Kubernetes with approvals
- **Observability**: Alerts + logging plan; pipeline monitoring and release health
- **Security**: Key Vault integration + gated checks (quality + security)
- **(Optional) MLOps**: Train a small model, register, deploy endpoint, monitor drift
- **(Optional) LLMOps**: Add a RAG endpoint; track prompt versions; run evals and monitor safety

## Suggested Assessment Checklist (End of Course)
- You can explain and implement **branch policies** and a **PR workflow**
- You can write a **multi-stage YAML pipeline** with environments and approvals
- You can build and ship a **Dockerized app** and deploy it on **Kubernetes**
- You can provision infra with **Terraform** using **remote state** and **modules**
- You can integrate **Key Vault** and enforce **security/quality gates**
- You can define **observability signals** and set **alerts**
- You can describe how you’d run **MLOps** and **LLMOps** in production


