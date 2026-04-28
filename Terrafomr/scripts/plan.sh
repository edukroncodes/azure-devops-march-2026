#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_DIR="${ROOT_DIR}/environments/${ENVIRONMENT}"
VAR_FILE="${ENV_DIR}/terraform.tfvars"

if [[ ! -f "${VAR_FILE}" ]]; then
  echo "Missing ${VAR_FILE}. Copy terraform.tfvars.example and fill real values." >&2
  exit 1
fi

terraform -chdir="${ENV_DIR}" fmt -recursive
terraform -chdir="${ENV_DIR}" validate
terraform -chdir="${ENV_DIR}" plan -var-file="${VAR_FILE}" -out="${ENVIRONMENT}.tfplan"
