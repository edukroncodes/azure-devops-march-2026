param(
  [string]$Environment = "dev"
)

$ErrorActionPreference = "Stop"
$RootDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$EnvDir = Join-Path $RootDir "environments\$Environment"
$PlanFile = Join-Path $EnvDir "$Environment.tfplan"

if (-not (Test-Path $PlanFile)) {
  Write-Error "Missing $PlanFile. Run scripts\plan.ps1 $Environment first."
}

terraform -chdir="$EnvDir" apply "$PlanFile"
