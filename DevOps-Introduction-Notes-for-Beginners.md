# DevOps Introduction Notes (Beginner Friendly) — with Azure DevOps Tool Mapping

These notes are written for **new students** who are learning DevOps from scratch. The goal is to explain DevOps in **simple terms**, compare it to a **normal computer**, and show the **matching Azure DevOps tools**.

---

## What is DevOps? (Simple definition)
**DevOps** is a way of working where **developers (Dev)** and **operations/IT (Ops)** work together to:
- build software faster,
- release it safely,
- fix problems quickly,
- and keep it running reliably.

DevOps is not only “tools”. It’s also:
- **people** (teamwork),
- **process** (how we work),
- and **automation** (repeatable steps).

---

## Normal Software Development vs DevOps (Key difference)

### Traditional approach (older style)
- Developers write code → “throw it over the wall” to Ops.
- Ops deploys and runs it.
- If it breaks, blame games can happen.
- Releases are slower because work moves in **separate silos**.

### DevOps approach (modern style)
- Developers and Ops plan together.
- Teams automate build, test, deploy.
- Everyone shares responsibility for quality and reliability.
- Releases are faster because work is **collaborative and automated**.

---

## DevOps Lifecycle (the “assembly line” of software)
DevOps is often explained as a loop:

1) **Plan** → decide what to build  
2) **Code** → write code  
3) **Build** → compile/package  
4) **Test** → check quality  
5) **Release** → prepare a deployable version  
6) **Deploy** → put it into an environment (dev/test/prod)  
7) **Operate** → keep it running  
8) **Monitor** → measure health, logs, alerts  
9) **Improve** → learn and repeat the loop

---

## DevOps compared to a normal computer (easy analogy)
Think of DevOps like building and running a computer system smoothly.

### Big idea
- A **computer** works well when hardware + OS + apps + updates + security + monitoring all work together.
- **DevOps** works well when planning + code + build + deploy + security + monitoring all work together.

---

## Computer vs DevOps vs Azure DevOps Tools (Mapping Table)

| Normal computer concept | In simple words | DevOps meaning | Azure DevOps tool(s) that match |
|---|---|---|---|
| **CPU (processor)** | Does the work/processing | Runs the automated steps (build/test/deploy tasks) | **Azure Pipelines** (jobs/steps/tasks run on agents) |
| **RAM** | Short-term memory | Temporary workspace during builds/tests | **Pipeline agent workspace** (build directory, temp files) |
| **Hard disk/SSD** | Stores files permanently | Stores code, build outputs, packages | **Azure Repos** (code), **Artifacts** (packages), pipeline **Artifacts** |
| **Operating System** | Controls how programs run | Rules/standards for how delivery happens | **Branch policies**, pipeline standards, templates, approvals/checks |
| **File system folders** | Organizes files | Repo structure and artifact organization | Repo layout + artifact naming/versioning |
| **Network/Wi‑Fi** | Connects to internet/services | Connects pipeline to cloud/servers/K8s | **Service connections**, agent network access |
| **User account & login** | Who can use the computer | Permissions and access control | **Azure DevOps security**: users, groups, permissions |
| **Antivirus / firewall** | Protects the computer | Security checks in pipeline and secrets protection | **Key Vault integration**, security gates (SAST/SCA scans) |
| **Task Manager** | Shows running apps and issues | Observes pipeline runs and failures | **Pipelines run logs**, approvals history |
| **System logs** | Records events and errors | App/service logs + pipeline logs | **Pipeline logs**, plus Azure monitoring tools (Monitor, App Insights) |
| **Updates** | Regular patches for stability | Frequent safe releases | **CI/CD pipelines** + release strategies (rolling/canary/blue-green) |
| **Backups/Restore** | Recover when disk fails | Rollback or redeploy safe versions | Versioned **artifacts**, deployment rollback, Git history |

---

## Azure DevOps: What each service does (Beginner explanation)

### 1) Azure Boards (Planning)
**What it is:** A digital notebook to plan and track work.  
**You use it for:**  
- user stories, tasks, bugs  
- sprints (weekly/biweekly plans)  
- Kanban board (To Do → Doing → Done)

**Simple classroom example:**  
“Build a login page” becomes a **story**, with tasks like UI, API, validation, tests.

---

### 2) Azure Repos (Source Code)
**What it is:** A safe place to store code using **Git**.  
**You use it for:**  
- saving versions of code (history)  
- branching (work safely without breaking main code)  
- pull requests (team review before merging)

**Simple classroom example:**  
Students create a feature branch, push code, open a PR, get review, merge safely.

---

### 3) Azure Pipelines (CI/CD Automation)
**What it is:** The “robot worker” that builds, tests, and deploys your code.  
**You use it for:**
- **CI (Continuous Integration)**: build + test every time code changes  
- **CD (Continuous Delivery/Deployment)**: deploy to environments automatically (with approvals if needed)

**Important simple idea:**  
If a pipeline fails, it’s like a **red signal** that says: “Don’t release yet—fix first.”

---

### 4) Azure Artifacts (Packages)
**What it is:** A store for reusable packages (like libraries).  
**You use it for:**
- publishing packages (NuGet/npm/Maven/PyPI style feeds)  
- versioning packages (v1.0.0, v1.1.0)  
- consuming packages in builds

**Simple classroom example:**  
Create a shared “utilities” package and reuse it across projects.

---

### (Optional but common) Azure Test Plans (Testing management)
**What it is:** A place to manage manual test cases and test plans.  
**Why it matters:** Not every test is automated, especially in beginner projects.

---

## Core DevOps Terms (Explain like I’m new)

### Continuous Integration (CI)
**Meaning:** Every time code changes, we automatically:
- compile/build,
- run tests,
- and produce a usable output (artifact).

**Why:** Catch problems early (before production).

### Continuous Delivery (CD)
**Meaning:** The code is always in a deployable state, and deployment is one click or approval away.

### Continuous Deployment (also CD)
**Meaning:** Deploy happens automatically after passing checks (no human approval).

### Artifact
**Meaning:** The “final packaged output” of a build.  
Examples: `.zip`, `.jar`, Docker image tag/digest, compiled binaries.

### Environment
**Meaning:** A place where software runs:
- dev (developer testing),
- test/qa,
- staging,
- production.

---

## Why DevOps matters (business + technical benefits)
- **Faster delivery**: release features sooner
- **Better quality**: automated tests reduce bugs
- **Lower risk**: small frequent changes are safer than big releases
- **Faster recovery**: monitoring + rollback helps fix issues quickly
- **Transparency**: everyone can see progress (Boards) and pipeline results (Pipelines)

---

## How a typical DevOps flow looks in Azure DevOps (end-to-end)

1) **Boards**: Create a story/task  
2) **Repos**: Create a branch and commit code  
3) **Repos**: Open a PR for review  
4) **Pipelines (CI)**: Build + test automatically on PR  
5) **Pipelines (CD)**: Deploy to dev/test environments  
6) **Approvals**: Optional approval before production  
7) **Monitor**: Track errors/latency after release  
8) **Improve**: Create new work items based on issues/feedback

---

## Classroom-style examples (very simple)

### Example A: “Hello World” API
- Students push code
- Pipeline runs tests
- Pipeline packages app
- Pipeline deploys to a test environment

### Example B: “Bug fix”
- Student creates a bug in Boards
- Fixes in a branch
- Opens PR
- CI validates
- Merges and deploys

---

## Best beginner habits (easy rules)
- **Small commits** (don’t change 50 files at once)
- **Short-lived branches** (merge frequently)
- **Always use PRs** for merging to `main`
- **Automate tests early** (even simple ones)
- **Don’t store secrets in code** (use secure storage like Key Vault)
- **Watch pipeline results** like exam scores (green = good, red = fix)

---

## Quick glossary (for first-week students)
- **Repo**: A project folder with history (Git)
- **Commit**: A saved change with a message
- **Branch**: A separate line of work
- **PR (Pull Request)**: A request to merge code after review
- **Pipeline**: Automated workflow (build/test/deploy)
- **Agent**: The machine that runs pipeline steps
- **Artifact**: Build output stored for deployment
- **Environment**: Where the software runs (dev/test/prod)

