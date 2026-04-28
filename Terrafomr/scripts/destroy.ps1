param(
  [string]$Environment = "dev"
)

$ErrorActionPreference = "Stop"
$RootDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$EnvDir = Join-Path $RootDir "environments\$Environment"
$VarFile = Join-Path $EnvDir "terraform.tfvars"

if ($Environment -eq "prod") {
  Write-Error "Refusing to destroy prod from helper script."
}

terraform -chdir="$EnvDir" destroy -var-file="$VarFile"
