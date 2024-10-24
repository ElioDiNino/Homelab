# Caddy

I use Caddy as a reverse proxy for my services. I use a custom build that includes the Cloudflare DNS plugin for automatic SSL certificate management.

## Commands

### Start services

```sh
sudo docker compose up -d
```

### Stop services

```sh
sudo docker compose down
```

### Reload Caddyfile

```sh
sudo docker exec -w /etc/caddy caddy-caddy-1 caddy reload
```

### Update services

```sh
sudo docker compose build
sudo docker compose up -d
```
