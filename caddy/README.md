# Caddy

I use Caddy as a reverse proxy for my services. I use a custom build that includes the Cloudflare DNS plugin for automatic SSL certificate management.

## Commands

### Start services

```sh
docker-compose up -d
```

### Stop services

```sh
docker-compose down
```

## Reload Caddyfile

```sh
docker exec -w /etc/caddy caddy-caddy-1 caddy reload
```
