# Muriel HA Promtail Add-on

Custom Home Assistant add-on that runs vanilla `grafana/promtail:latest` with journald scraping.

## Add-on Repo

Add this repo to Home Assistant:

```
https://github.com/Muriel2Horak/ha-promtail
```

## Add-on Location

The add-on is located in `/addon` and uses `config.json` for discovery.

## Add-on Settings

- Loki URL: `http://10.0.0.160:3100/loki/api/v1/push`
- Optional auth: username/password
- Optional TLS: cafile/certfile/keyfile/servername (use paths inside add-on, e.g. `/ssl/...`)

## Notes

- Journald scraping only (no file fallback)
- Requires privileged/full access to read journal
