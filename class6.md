# Azure CI/CD Pipeline – Complete Services Table

## 1️⃣ Source Control / Versioning

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Azure Repos | Git repository, code management | Store frontend/backend code for cart service |
| GitHub | External Git repo | Team collaboration on payment microservice |
| GitHub Actions | CI/CD automation for GitHub | Build and test “Add to Cart” feature automatically |
| Azure DevOps Services | Integrated source control | Multi-team development workflow |
| Branch Policies | Enforce code review and PR approvals | Ensure checkout logic is peer-reviewed |

---

## 2️⃣ CI/CD / Build & Deployment

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Azure Pipelines | CI/CD automation | Deploy checkout microservice |
| Build Pipelines | Automate builds | Compile backend services |
| Release Pipelines | Deploy to dev/QA/prod | Deploy “Buy Now” feature to production |
| YAML Pipelines | Pipelines as code | Version-controlled CI/CD definition |
| Self-hosted Agents | Custom build servers | Build .NET backend |
| Microsoft-hosted Agents | Managed build agents | Run Node.js frontend builds |
| Pipeline Triggers | Auto-start pipelines | Trigger build after code push |
| Multi-stage Pipelines | Full CI/CD flow | Build → Test → Deploy cart service |
| Parallel Jobs | Faster builds | Build frontend & backend simultaneously |
| Approval Gates | Manual approval in CD | QA approves checkout deployment |
| Deployment Groups | VM-based deployments | Update payment service across multiple VMs |
| Environments | Manage Dev/QA/Prod | Separate staging and production |
| Pipeline Artifacts | Share build outputs | Store compiled frontend code |
| Service Connections | Connect external services | Deploy to Azure App Service |
| Variable Groups | Centralized pipeline configs | Store DB connection strings |

---

## 3️⃣ Testing / QA Tools

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Azure Test Plans | Manual & exploratory testing | Validate checkout and payment flows |
| Test Suites | Group test cases | Payment gateway tests |
| Test Cases | Individual test steps | Apply discount coupon scenario |
| Test Run | Execute test cases | Run all checkout tests before release |
| Test Configuration | Browser/OS configurations | Test mobile and desktop UX |
| Test Results Task | Publish test results | Show passed/failed tests for QA |
| Code Coverage | Measure code quality | Ensure price calculation logic is fully tested |
| Exploratory Testing | Unscripted QA testing | Randomly test cart behavior |
| Regression Testing | Retest after changes | Ensure order system works after new feature |
| Bug Tracking | Log defects | Track payment API failures |

---

## 4️⃣ Package Management

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Azure Artifacts | Store NuGet/npm/Maven packages | Reusable discount calculation module |
| NuGet Task | .NET package management | Package order service library |
| npm Task | Node.js package management | Manage frontend dependencies |
| Maven Task | Java package builds | Backend service dependencies |
| Pipeline Artifacts | Share compiled packages | Deploy microservices artifacts |

---

## 5️⃣ Infrastructure as Code (IaC) & Automation

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| ARM Templates | Declaratively provision Azure resources | Deploy VMs, AKS clusters |
| Terraform (Azure) | Multi-cloud IaC | Deploy scalable AKS cluster |
| Azure Automation | Automate repetitive tasks | Scale VMs during flash sale |
| Azure CLI | Command-line automation | Script deployments |
| PowerShell Task | Windows automation | Backup SQL database before deployment |
| Bash Task | Linux automation | Restart backend containers |
| Service Connections | Connect infra services | Deploy Redis cache for cart |
| Variable Groups | Store infrastructure configs | DB connection strings |
| Secure Files | Store certificates | SSL certificate for checkout service |
| Pipeline Tasks | Run infra pipelines | Deploy new Redis cluster |

---

## 6️⃣ Containers & Kubernetes

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Docker Task | Build container images | Package product microservice |
| Helm Task | Manage Kubernetes deployments | Deploy checkout service in AKS |
| Kubernetes Task | Deploy apps to AKS | Deploy all microservices |
| Azure Container Instances | Lightweight container hosting | Run cart service container temporarily |
| Azure Kubernetes Service (AKS) | Managed Kubernetes | Auto-scale inventory service containers |

---

## 7️⃣ Monitoring & Observability

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Azure Monitor | Metrics & health monitoring | Track checkout API latency |
| Log Analytics | Query logs | Find failed payment requests |
| Application Insights | Application performance monitoring | Detect slow product page load |
| Azure Alerts | Notifications | Alert on spikes of failed orders |
| Dashboards | Visualize metrics | Show live sales metrics |
| Azure Metrics | Time-series metrics | Monitor CPU usage on VMs |
| Container Insights | K8s monitoring | Monitor cart service containers |
| Network Watcher | Network monitoring | Monitor traffic from frontend to backend |
| Azure Advisor | Recommendations | Optimize cost during high load |
| Workbooks | Custom dashboards | Track user sessions and conversions |

---

## 8️⃣ Security & Secrets

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Azure Key Vault | Store secrets & certificates | Payment API credentials |
| Secure Files | Certificate storage | SSL certificate for storefront |
| Azure Active Directory | Identity & access management | Admin portal access |
| Role-based Access Control (RBAC) | Fine-grained access control | Only devs can deploy to prod |
| Pipeline Variables (secret) | Pipeline secrets | DB passwords during CI/CD |

---

## 9️⃣ Networking & Connectivity

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Virtual Network (VNet) | Isolate resources | Separate frontend & backend networks |
| VPN Gateway | Secure site-to-site connectivity | Office network → Azure |
| ExpressRoute | Private Azure connection | Fast payment processing |
| Application Gateway | Web load balancer + WAF | Secure checkout endpoints |
| Traffic Manager | DNS load balancing | Route users to nearest region |
| Front Door | Global LB + CDN | Deliver product images worldwide |
| Network Security Groups | Filter traffic | Allow API calls only from frontend |
| Azure Firewall | Central network security | Filter payment gateway access |
| DDoS Protection | Protect against attacks | Prevent downtime during flash sale |
| Azure Bastion | Secure RDP/SSH | Admin connects securely to backend VM |

---

## 10️⃣ Project Management & Collaboration

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Azure Boards | Track tasks & bugs | Track “Fix checkout bug” |
| Azure Wiki | Documentation | Share system design for flash sale |
| Pull Requests | Code review | Review discount feature before merge |
| Dashboards | Team metrics | Track sprint progress |
| Work Items | Feature & bug tracking | Log “Add Wishlist” feature request |

---

## 11️⃣ Serverless & Event-Driven

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Azure Functions | Serverless code execution | Send confirmation emails on order |
| Event Grid | Event routing | Trigger discount calculation workflow |
| Logic Apps | Workflow automation | Integrate payment gateway |
| Service Bus | Messaging queue | Queue orders for asynchronous processing |
| Event Hubs | Event ingestion | Stream analytics for user clicks & transactions |

---

## 12️⃣ Backup & Disaster Recovery

| Service | Purpose | E-commerce Example |
|---------|---------|------------------|
| Azure Backup | Backup VMs & databases | Backup order database |
| Azure Site Recovery | Disaster recovery | Failover store to secondary region |
| Recovery Services Vault | Centralized backup | Manage multiple backup policies |
| Storage Account Snapshots | Point-in-time recovery | Recover product catalog DB |
| Soft Delete | Protect deleted data | Recover accidentally deleted order record |

# Azure Infrastructure & Tools Notes

---

## **1. Infra Tools**

### **1.1 ARM (Azure Resource Manager)**
- Service for managing Azure resources declaratively.
- Key Functions:
  - Deploy and manage databases, web servers, VMs, and other Azure resources.
  - Enables **infrastructure as code** using JSON templates.
  - Provides **role-based access control (RBAC)** and resource tagging.

### **1.2 Terraform**
- **Multi-cloud infrastructure provisioning** tool.
- Key Features:
  - Can manage Azure, AWS, GCP, and on-prem resources.
  - Declarative syntax using `.tf` files.
  - Tracks infrastructure state for **idempotent deployments**.

### **1.3 Azure VMs**
- Virtual machines running in the cloud.
- Key Uses:
  - Host applications, test environments, or backend services.
  - Choose from different sizes, OS, and regions.
  - Can integrate with **Azure Disks**, backups, and monitoring.

### **1.4 AKS (Azure Kubernetes Service)**
- Managed Kubernetes for **deploying and scaling containerized apps**.
- Features:
  - Automated cluster management, scaling, and updates.
  - Integration with Azure networking, storage, and monitoring.

### **1.5 Azure App Services**
- Platform-as-a-Service (PaaS) for **web apps and APIs**.
- Key Uses:
  - Host front-end apps like React, Angular, or Vue.
  - Deploy APIs with Node.js, .NET, or Python.
  - Built-in scaling, monitoring, and authentication.

### **1.6 Azure Functions**
- Serverless compute for running small code snippets triggered by events.
- Features:
  - Event-driven (HTTP, queue, timer triggers, etc.).
  - Scales automatically based on demand.
  - Ideal for microservices and automation tasks.

### **1.7 Azure Storage**
- Types:
  - **Blob Storage:** Store unstructured data like files and images.
  - **File Storage:** Managed file shares.
  - **Queue Storage:** Messaging between applications.
  - **Table Storage:** NoSQL key-value store.

### **1.8 Azure SQL Database**
- Fully-managed relational database service.
- Features:
  - Auto-scaling, backups, and high availability.
  - Supports T-SQL and integration with other Azure services.

### **1.9 Azure Managed Disks**
- Persistent storage for Azure VMs.
- Types:
  - Standard HDD, Standard SSD, Premium SSD.
- Provides **high availability, durability, and snapshots**.

### **1.10 Azure Load Balancer**
- Distributes incoming traffic across VMs or services.
- Types:
  - **Public Load Balancer:** Internet-facing.
  - **Internal Load Balancer:** Private network only.

### **1.11 Azure Backup**
- Managed backup solution for Azure VMs, SQL, and on-prem data.
- Features:
  - Incremental backups, retention policies, and recovery options.

### **1.12 Azure Site Recovery**
- Disaster recovery service.
- Features:
  - Replicates VMs to another Azure region or on-prem.
  - Supports failover testing and automatic failover.

### **1.13 Azure Automation**
- Automates repetitive tasks using runbooks and scripts.
- Integrates with VMs, storage, and other services.

---

## **2. Networking & Connectivity**

### **2.1 Azure VNet**
- Virtual Network to **isolate and connect Azure resources**.
- Features:
  - Subnets, IP addressing, route tables, and network security.

### **2.2 VPN Gateway**
- Secure connection between on-premises and Azure.
- Types:
  - **Site-to-Site VPN:** Connect entire networks.
  - **Point-to-Site VPN:** Individual device access.

### **2.3 Azure ExpressRoute**
- Private, high-speed connection between on-premises and Azure.
- Not over the public internet → lower latency & higher security.

### **2.4 Azure Application Gateway**
- Layer-7 load balancer (HTTP/HTTPS).
- Features:
  - URL-based routing.
  - SSL termination.
  - Web Application Firewall (WAF) integration.

### **2.5 Azure Front Door**
- Global, scalable entry point for web apps.
- Features:
  - Routing based on latency and geography.
  - DDoS protection and caching.

### **2.6 Network Security Groups (NSG)**
- Filter network traffic to/from Azure resources.
- Rules based on IP, port, and protocol.

### **2.7 Azure Firewall**
- Managed, cloud-based network security service.
- Features:
  - Threat intelligence.
  - Application & network-level filtering.

### **2.8 Azure CDN**
- Content Delivery Network for caching and delivering static content.
- Reduces latency for global users.

### **2.9 Azure Bastion**
- Securely access VMs via browser.
- Avoids public IP exposure.

---

## **3. Security & Secrets**

### **3.1 Azure Key Vault**
- Secure storage for secrets, keys, and certificates.
- Features:
  - Access policies and RBAC.
  - Integration with Azure services for automated key management.

### **3.2 Azure Active Directory (AAD)**
- Identity and access management service.
- Features:
  - Single Sign-On (SSO).
  - Multi-Factor Authentication (MFA).
  - Application and user management.

### **3.3 Role-Based Access Control (RBAC)**
- Assign granular access to resources.
- Roles:
  - Owner, Contributor, Reader, Custom roles.
- Scope: Subscription, Resource Group, Resource.

---

**✅ Summary:**  
- Azure provides a wide range of **infrastructure, networking, and security services**.  
- Tools like **ARM, Terraform, AKS, and Azure Functions** help automate, scale, and manage resources efficiently.  
- Networking features ensure secure connectivity and global reach.  
- Security services like **Key Vault, AAD, and RBAC** protect sensitive data and control access.
