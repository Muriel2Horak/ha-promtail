#!/usr/bin/with-contenv bash
set -euo pipefail

OPTIONS_PATH=/data/options.json
if [ -f "$OPTIONS_PATH" ]; then
  LOG_LEVEL=$(jq -r '.log_level // "info"' "$OPTIONS_PATH")
  if [ -n "$LOG_LEVEL" ]; then
    export PROMTAIL_LOG_LEVEL="$LOG_LEVEL"
  fi
fi
