#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_DIR="${ROOT_DIR}/environments/${ENVIRONMENT}"
PLAN_FILE="${ENV_DIR}/${ENVIRONMENT}.tfplan"

if [[ ! -f "${PLAN_FILE}" ]]; then
  echo "Missing ${PLAN_FILE}. Run scripts/plan.sh ${ENVIRONMENT} first." >&2
  exit 1
fi

terraform -chdir="${ENV_DIR}" apply "${PLAN_FILE}"
