ARG BUILD_FROM=grafana/promtail:latest
FROM ${BUILD_FROM}

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq bash \
    && rm -rf /var/lib/apt/lists/*

COPY rootfs /

# Make scripts executable
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
