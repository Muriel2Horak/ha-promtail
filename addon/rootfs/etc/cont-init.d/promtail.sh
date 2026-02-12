#!/usr/bin/with-contenv bash
set -euo pipefail

OPTIONS_PATH=/data/options.json
CONFIG_PATH=/etc/promtail/config.yml

if [ ! -f "$OPTIONS_PATH" ]; then
  echo "Missing options file: $OPTIONS_PATH" >&2
  exit 1
fi

url=$(jq -r '.client.url' "$OPTIONS_PATH")
username=$(jq -r '.client.username // ""' "$OPTIONS_PATH")
password=$(jq -r '.client.password // ""' "$OPTIONS_PATH")
cafile=$(jq -r '.client.cafile // ""' "$OPTIONS_PATH")
certfile=$(jq -r '.client.certfile // ""' "$OPTIONS_PATH")
keyfile=$(jq -r '.client.keyfile // ""' "$OPTIONS_PATH")
servername=$(jq -r '.client.servername // ""' "$OPTIONS_PATH")
log_level=$(jq -r '.log_level // "info"' "$OPTIONS_PATH")

cat > "$CONFIG_PATH" <<EOFCONF
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: $url
EOFCONF

if [ -n "$username" ]; then
  echo "    username: $username" >> "$CONFIG_PATH"
fi
if [ -n "$password" ]; then
  echo "    password: $password" >> "$CONFIG_PATH"
fi

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

cat >> "$CONFIG_PATH" <<EOFCONF

scrape_configs:
  - job_name: haos-journal
    journal:
      max_age: 12h
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

export PROMTAIL_LOG_LEVEL="$log_level"
