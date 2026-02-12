#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Starting HA Promtail add-on..."

OPTIONS_PATH=/data/options.json
CONFIG_PATH=/etc/promtail/config.yml

# Check if options file exists
if [ ! -f "$OPTIONS_PATH" ]; then
  echo "[ERROR] Missing options file: $OPTIONS_PATH" >&2
  exit 1
fi

echo "[INFO] Reading configuration from $OPTIONS_PATH..."

# Read configuration from Home Assistant options
url=$(jq -r '.client.url' "$OPTIONS_PATH")
username=$(jq -r '.client.username // ""' "$OPTIONS_PATH")
password=$(jq -r '.client.password // ""' "$OPTIONS_PATH")
cafile=$(jq -r '.client.cafile // ""' "$OPTIONS_PATH")
certfile=$(jq -r '.client.certfile // ""' "$OPTIONS_PATH")
keyfile=$(jq -r '.client.keyfile // ""' "$OPTIONS_PATH")
servername=$(jq -r '.client.servername // ""' "$OPTIONS_PATH")
log_level=$(jq -r '.log_level // "info"' "$OPTIONS_PATH")

echo "[INFO] Generating Promtail configuration..."

# Generate Promtail configuration
cat > "$CONFIG_PATH" <<EOFCONF
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: $url
EOFCONF

# Add optional authentication
if [ -n "$username" ]; then
  echo "    username: $username" >> "$CONFIG_PATH"
fi
if [ -n "$password" ]; then
  echo "    password: $password" >> "$CONFIG_PATH"
fi

# Add optional TLS configuration
if [ -n "$cafile" ] || [ -n "$certfile" ] || [ -n "$keyfile" ] || [ -n "$servername" ]; then
  echo "    tls_config:" >> "$CONFIG_PATH"
  if [ -n "$cafile" ]; then
    echo "      ca_file: $cafile" >> "$CONFIG_PATH"
  fi
  if [ -n "$certfile" ]; then
    echo "      cert_file: $certfile" >> "$CONFIG_PATH"
  fi
  if [ -n "$keyfile" ]; then
    echo "      key_file: $keyfile" >> "$CONFIG_PATH"
  fi
  if [ -n "$servername" ]; then
    echo "      server_name: $servername" >> "$CONFIG_PATH"
  fi
fi

# Add scrape configuration for journald
cat >> "$CONFIG_PATH" <<EOFCONF

scrape_configs:
  - job_name: haos-journal
    journal:
      max_age: 1h
      json: false
      labels:
        job: systemd-journal
      path: /var/log/journal
    relabel_configs:
      - source_labels: [__journal__systemd_unit]
        target_label: unit
      - source_labels: [__journal__hostname]
        target_label: nodename
      - source_labels: [__journal_syslog_identifier]
        target_label: syslog_identifier
      - source_labels: [__journal_container_name]
        target_label: container_name
EOFCONF

echo "[INFO] Promtail configuration generated successfully"
echo "[INFO] Loki URL: $url"
echo "[INFO] Log level: $log_level"

# Debug: show generated config
echo "[DEBUG] === Generated Promtail config ==="
cat "$CONFIG_PATH"
echo "[DEBUG] === End config ==="

# Debug: check journal path
echo "[DEBUG] === Checking /var/log/journal ==="
ls -la /var/log/journal/ 2>&1 || echo "[DEBUG] /var/log/journal does NOT exist"
echo "[DEBUG] === Checking /run/log/journal ==="
ls -la /run/log/journal/ 2>&1 || echo "[DEBUG] /run/log/journal does NOT exist"

# Debug: check if journald is accessible
echo "[DEBUG] === Checking journalctl ==="
which journalctl 2>&1 || echo "[DEBUG] journalctl not found"
journalctl --no-pager -n 3 2>&1 || echo "[DEBUG] journalctl cannot read logs"

# Debug: check promtail binary
echo "[DEBUG] === Promtail binary ==="
ls -la /usr/bin/promtail 2>&1
/usr/bin/promtail --version 2>&1 || true

# Debug: check options.json
echo "[DEBUG] === options.json ==="
cat "$OPTIONS_PATH"

# Debug: connectivity to Loki
echo "[DEBUG] === Testing Loki connectivity ==="
curl -s -o /dev/null -w "HTTP Status: %{http_code}" "$url" 2>&1 || echo "[DEBUG] Cannot reach Loki at $url"

echo "[INFO] Starting Promtail..."

# Start Promtail
exec /usr/bin/promtail -config.file="$CONFIG_PATH" -log.level="$log_level"
