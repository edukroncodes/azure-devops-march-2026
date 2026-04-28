param(
  [string]$Environment = "dev"
)

$ErrorActionPreference = "Stop"
$RootDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$EnvDir = Join-Path $RootDir "environments\$Environment"
$VarFile = Join-Path $EnvDir "terraform.tfvars"

if (-not (Test-Path $VarFile)) {
  Write-Error "Missing $VarFile. Copy terraform.tfvars.example and fill real values."
}

terraform -chdir="$EnvDir" fmt -recursive
terraform -chdir="$EnvDir" validate
terraform -chdir="$EnvDir" plan -var-file="$VarFile" -out="$Environment.tfplan"
