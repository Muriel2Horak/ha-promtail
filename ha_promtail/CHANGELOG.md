# Changelog

## 0.1.8
- **FIX**: Reduce journal max_age from 12h to 1h
- Prevents "entry too far behind" errors when Loki rejects old logs
- Promtail now only reads journal entries from the last hour on startup

## 0.1.7
- **CRITICAL FIX**: Remove s6-overlay dependency from Dockerfile
- Rewrite entrypoint to run directly with bash instead of s6-overlay
- Fix "exec: /usr/bin/with-contenv: no such file or directory" error
- Combine all initialization and execution into single /run.sh script

## 0.1.6
- **CRITICAL FIX**: Remove invalid 'SYSLOG' and 'SYS_CHROOT' from privileged capabilities
- These are not valid Linux capabilities in Home Assistant
- Addon should now load correctly in Supervisor

## 0.1.5
- Fix repository structure for HA marketplace visibility
- Convert build configuration to YAML format
- Pin Promtail to version 3.3.2 (instead of 'latest')
- Add icon and logo for better marketplace presentation
- Consolidate addon structure to meet HA requirements

## 0.1.3
- Mark add-on as stable

## 0.1.2
- Force repository refresh

## 0.1.1
- Fix add-on discovery by bumping version

## 0.1.0
- Initial release: journald scraping to Loki with optional TLS auth
