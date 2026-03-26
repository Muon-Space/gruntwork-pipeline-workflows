#!/usr/bin/env bash
# Enrich orchestrate output with GitHub Environment names derived from WorkingDirectory.
# e.g. network-inspection/production/account_baseline -> network-inspection-production
# This follows the convention that .gruntwork/ environment labels match <system>-<environment>.
set -euo pipefail

if [ -z "${ORCHESTRATE_JOBS:-}" ] || [ "$ORCHESTRATE_JOBS" = "[]" ]; then
  echo "jobs=[]" >> "$GITHUB_OUTPUT"
else
  ENRICHED=$(echo "$ORCHESTRATE_JOBS" | jq -c '[.[] | . + {Environment: (.WorkingDirectory | split("/") | .[0:2] | join("-"))}]')
  {
    echo "jobs<<ENRICH_EOF"
    echo "$ENRICHED"
    echo "ENRICH_EOF"
  } >> "$GITHUB_OUTPUT"
fi
