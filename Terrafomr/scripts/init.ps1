param(
  [string]$Environment = "dev"
)

$ErrorActionPreference = "Stop"
$RootDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$EnvDir = Join-Path $RootDir "environments\$Environment"

if (-not (Test-Path $EnvDir)) {
  Write-Error "Unknown environment: $Environment. Expected one of: dev, qa, prod"
}

terraform -chdir="$EnvDir" init -upgrade
