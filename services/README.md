# Self-Hosted Services

You can find the configurations for each of the services I self-host in the accompanying directories, with descriptions of each [below](#services).

The services are managed using [Portainer](#portainer) and [Docker Compose](https://docs.docker.com/compose/). For just Docker Compose usage, you can use the following commands:

## Commands

### Create `.env` file

```sh
cp .env.example .env
# Fill in the required variables
```

### Start services

```sh
sudo docker network create proxy-internal
sudo docker compose up -d
```

### Stop services

```sh
sudo docker compose down
```

### Update services

```sh
sudo docker compose pull
sudo docker compose up -d
sudo docker image prune -f
```

## Services

### [Portainer](./portainer/)

[Portainer](https://portainer.io/) is a lightweight management UI that allows you to easily manage your Docker containers, images, networks, and volumes. I use it to deploy and manage my self-hosted services, using the GitOps feature to automatically deploy changes to my services when I push to this repository. I also run a Portainer agent on my ODROID N2+ to manage the staging environment.

### [Caddy](./caddy/)

I use [Caddy](https://caddyserver.com/) as the reverse proxy for my services due to its robust feature set and ease of use. I use a custom build that includes the [Caddy-Docker-Proxy](https://github.com/lucaslorentz/caddy-docker-proxy) and [Cloudflare DNS](https://github.com/caddy-dns/cloudflare) plugins for label-based configuration and automatic SSL certificate management.

### [Beszel](./beszel/)

[Beszel](https://beszel.dev/) is a lightweight server monitoring platform that includes Docker statistics, historical data, and alert functions. I use it as the main monitoring tool for my homelab, providing insights into the performance and health of my services.

### [Diun](./diun/)

[Docker Image Update Notifier (Diun)](https://crazymax.dev/diun/) is an application for receiving notifications when a Docker image is updated on a Docker registry. I use it to monitor my important containers and notify me via 3rd-party integrations when a new image version is found.

### [Docker Socket Proxy](./socket-proxy/)

Due to some services' reliance on connection to the docker socket, I use [Docker Socket Proxy](https://github.com/11notes/docker-socket-proxy) to securely expose the Docker API to my services in read-only mode without giving them direct access to the Docker daemon (with the exception of Portainer, which requires full access).

### [Stirling PDF](./stirling-pdf/)

I use [Stirling PDF](https://www.stirlingpdf.com/) for all my PDF needs. It is a self-hosted tool that allows you to merge, split, and manipulate PDF files easily without giving up your privacy.

### [Spotify Dashboard](./spotify-dashboard/)

[Spotify Dashboard](https://github.com/Yooooomi/your_spotify) is purely for displaying historical listening data. It is not a replacement for the Spotify app, but rather a nice tool to visualize your listening habits and statistics over time.
