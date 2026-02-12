#!/usr/bin/with-contenv bash
set -euo pipefail

LOG_LEVEL=${PROMTAIL_LOG_LEVEL:-info}
exec /usr/bin/promtail -config.file=/etc/promtail/config.yml -log.level="$LOG_LEVEL"
