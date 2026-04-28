# Azure Terraform Ecommerce Platform

This repository contains a production-oriented Terraform scaffold for an ecommerce website targeting up to 100,000 concurrent users after application load testing and Azure quota validation.

## Architecture

- Azure Application Gateway WAF v2 for public ingress and OWASP protection.
- Azure Kubernetes Service for storefront, API, checkout, and worker workloads.
- Azure Container Registry for application images.
- Azure Database for PostgreSQL Flexible Server with private networking and zone redundant HA.
- Azure Cache for Redis Premium for sessions, carts, and hot catalog data.
- Azure Storage for media, invoices, and logs.
- Azure App Service for an admin portal or back-office application.
- Log Analytics and Azure Monitor for platform telemetry.

## Layout

```text
modules/          Reusable Terraform modules
environments/     dev, qa, and prod root modules
global/           Bootstrap remote state storage
backend/          Optional shared backend snippet
scripts/          Bash and PowerShell helper scripts
k8s/base/         Example Kubernetes scaling manifests
```

## First-Time Setup

1. Login to Azure:

   ```bash
   az login
   az account set --subscription "<subscription-id>"
   ```

2. Bootstrap Terraform remote state:

   ```bash
   terraform -chdir=global init
   terraform -chdir=global apply
   ```

3. For each environment, create a real variable file:

   ```bash
   cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
   ```

   Update the password, location, authorized IP ranges, and any naming values.

4. Initialize, plan, and deploy:

   ```bash
   ./scripts/init.sh dev
   ./scripts/plan.sh dev
   ./scripts/deploy.sh dev
   ```

   On Windows PowerShell:

   ```powershell
   .\scripts\init.ps1 dev
   .\scripts\plan.ps1 dev
   .\scripts\deploy.ps1 dev
   ```

## Production Sizing Notes

The `prod` environment is intentionally sized much larger than `dev` and `qa`:

- AKS user node pools scale up to hundreds of `Standard_D32ds_v5` nodes.
- Application Gateway WAF v2 scales up to 125 instances.
- PostgreSQL uses a memory optimized SKU with 2 TB storage.
- Redis Premium uses clustering.

These values are starting points, not a guarantee of handling 100,000 concurrent users. Real capacity depends on request rate, page weight, cache hit ratio, database query cost, payment flow latency, and application CPU/memory profile. Run load tests, set Azure regional quota ahead of time, and tune node pools and database size from measured bottlenecks.

## Important Changes Before Production

- Replace placeholder backend FQDNs like `ecommerce.prod.internal` after your ingress controller or service DNS is known.
- Add TLS certificates and HTTPS listeners to Application Gateway.
- Move secrets to Azure Key Vault and use workload identity from AKS/App Service.
- Add private endpoints for Storage, ACR, and Redis if your security baseline requires fully private data paths.
- Configure DNS, CDN/Front Door, DDoS Network Protection, and backup policies based on your domain and recovery targets.
- Commit only `terraform.tfvars.example`; keep real `terraform.tfvars` out of source control.

## Useful Commands

```bash
terraform -chdir=environments/prod fmt -recursive
terraform -chdir=environments/prod validate
terraform -chdir=environments/prod plan -var-file=terraform.tfvars
```

```powershell
terraform -chdir=environments/prod fmt -recursive
terraform -chdir=environments/prod validate
terraform -chdir=environments/prod plan -var-file=terraform.tfvars
```
