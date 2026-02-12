ARG BUILD_FROM=grafana/promtail:latest
FROM ${BUILD_FROM}

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq \
    && rm -rf /var/lib/apt/lists/*

COPY rootfs /

ENTRYPOINT ["/usr/bin/with-contenv", "/usr/bin/promtail-entry"]
