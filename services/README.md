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
sudo docker network create proxy-external
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

### [Pocket ID](./pocket-id/)

My authentication service of choice is [Pocket ID](https://pocket-id.org/). It is a self-hosted identity provider that supports OpenID Connect and OAuth 2.0, allowing me to manage user authentication and authorization for my applications securely. I chose it for its simplicity, clean UI, ease of integration, and focus on passwordless authentication.

### [Diun](./diun/)

[Docker Image Update Notifier (Diun)](https://crazymax.dev/diun/) is an application for receiving notifications when a Docker image is updated on a Docker registry. I use it to monitor my important containers and notify me via 3rd-party integrations when a new image version is found.

### [Docker Socket Proxy](./socket-proxy/)

Due to some services' reliance on connection to the docker socket, I use [Docker Socket Proxy](https://github.com/11notes/docker-socket-proxy) to securely expose the Docker API to my services in read-only mode without giving them direct access to the Docker daemon (with the exception of Portainer, which requires full access).

### [Immich](./immich/)

[Immich](https://immich.app/) is a self-hosted photo and video storage solution with functionality similar to Google Photos. It allows you to automatically back up your photos and videos from your devices, providing a web interface to view and manage your media. It is my primary photo and video management solution.

I also run [Immich Public Proxy](https://github.com/alangrainger/immich-public-proxy) to provide secure external access to link shares and public albums without exposing the main Immich server directly to the internet.

### [Cloudflared](./cloudflared/)

To facilitate secure public access to a subset of my services, I use [Cloudflared](https://github.com/cloudflare/cloudflared) to create secure tunnels to my internal services. This allows me to expose specific services to the internet without exposing my entire network.

### [Stirling PDF](./stirling-pdf/)

I use [Stirling PDF](https://www.stirlingpdf.com/) for all my PDF needs. It is a self-hosted tool that allows you to merge, split, and manipulate PDF files easily without giving up your privacy.

### [Spotify Dashboard](./spotify-dashboard/)

[Spotify Dashboard](https://github.com/Yooooomi/your_spotify) is purely for displaying historical listening data. It is not a replacement for the Spotify app, but rather a nice tool to visualize your listening habits and statistics over time.

### [Mazanoke](./mazanoke/)

I run [Mazanoke](https://mazanoke.com/) for easy photo compression and conversion. It provides a clean web interface and runs completely in the browser, making it a convenient tool for quick image processing tasks.
