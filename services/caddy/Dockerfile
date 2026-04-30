ARG CADDY_VERSION=2
FROM caddy:${CADDY_VERSION}-builder AS builder

# Build Caddy with the Cloudflare DNS, Caddy Docker Proxy, and Sablier Caddy plugins
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare@v0.2.4 \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2@v2.12.0 \
    --with github.com/sablierapp/sablier-caddy-plugin@v1.0.2

FROM caddy:${CADDY_VERSION}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]
