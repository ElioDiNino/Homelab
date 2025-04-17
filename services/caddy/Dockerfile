ARG CADDY_VERSION=2
FROM caddy:${CADDY_VERSION}-builder AS builder

# Build Caddy with the Caddy-Docker-Proxy and Cloudflare DNS plugins
RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:${CADDY_VERSION}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]
