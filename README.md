# Muriel HA Promtail Add-on

Custom Home Assistant add-on that runs Grafana Promtail with journald scraping for HAOS.

## Installation

1. Go to **Settings** → **Add-ons** → **Add-on Store**
2. Click the **⋮** menu in top right → **Repositories**
3. Add this repository URL:
   ```
   https://github.com/Muriel2Horak/ha-promtail
   ```
4. Find "HA Promtail" in the store and click **Install**

## Configuration

- **Loki URL**: Your Loki push endpoint (e.g., `http://10.0.0.160:3100/loki/api/v1/push`)
- **Authentication**: Optional username/password
- **TLS**: Optional cafile/certfile/keyfile/servername (use paths inside add-on, e.g. `/ssl/...`)

## Features

- ✅ Journald scraping from HAOS
- ✅ Direct Loki integration
- ✅ Optional TLS authentication
- ✅ Health check endpoint at port 9080
- ✅ Configurable log level

## Add-on Settings

| Setting | Description | Default |
|---------|-------------|---------|
| `client.url` | Loki push URL | `http://10.0.0.160:3100/loki/api/v1/push` |
| `client.username` | Optional HTTP username | `""` |
| `client.password` | Optional HTTP password | `""` |
| `client.cafile` | Optional CA file path | `""` |
| `client.certfile` | Optional client cert path | `""` |
| `client.keyfile` | Optional client key path | `""` |
| `client.servername` | Optional server name for TLS | `""` |
| `log_level` | Log level for Promtail | `info` |

## Notes

- Journald scraping only (no file fallback)
- Requires privileged/full access to read journal
- Port 9080 is exposed for health checks

## Version

Current version: **0.1.5**
- Promtail: 3.3.2
