#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_DIR="${ROOT_DIR}/environments/${ENVIRONMENT}"
VAR_FILE="${ENV_DIR}/terraform.tfvars"

if [[ "${ENVIRONMENT}" == "prod" ]]; then
  echo "Refusing to destroy prod from helper script." >&2
  exit 1
fi

terraform -chdir="${ENV_DIR}" destroy -var-file="${VAR_FILE}"
