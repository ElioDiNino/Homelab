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
docker network create proxy-internal
docker network create proxy-external
docker network create proxy-plausible --internal
docker network create proxy-immich-public --internal
docker compose up -d
```

### Stop services

```sh
docker compose down
```

### Update services

```sh
docker compose pull
docker compose up -d
docker image prune -f
```

## Network Diagram

This diagram gives an overview of the services I run and how they interact with each other and the outside world.

```mermaid
graph TB
    %% Groups

    subgraph "External Access"
        EXT[External Users]
        CF[Cloudflare]
    end

    subgraph "Internal Access"
        INT[Internal Users]
        TAILSCALE[Tailscale]
    end

    subgraph "Homelab Network"
        subgraph "Network Infrastructure"
            CF_TUNNEL[Cloudflare Tunnel]
            CADDY_EXT[External Reverse Proxy]
            IMMICH_PROXY[Immich Public Proxy]
            CADDY_INT[Internal Reverse Proxy]
            ERROR_PAGES[Custom Error Pages]
        end

        subgraph "User Services"
            IMMICH[Immich]
            PLAUSIBLE[Plausible]
            HOMEPAGE[Homepage]
            POCKET_ID[Pocket ID]
            GOTIFY[Gotify]
            HEALTHCHECKS[Healthchecks]
            UPTIME_KUMA[Uptime Kuma]
            STIRLING[Stirling PDF]
            MAZANOKE[Mazanoke]
            CONVERTX[ConvertX]
            IT_TOOLS[IT Tools]
            SPOTIFY[Spotify Dashboard]
            PORTAINER[Portainer]
            BESZEL_HUB[Beszel Hub]
            TINYAUTH[Tinyauth]
        end

        subgraph "Infrastructure Services"
            BESZEL_AGENT[Beszel Agent]
            DIUN[Diun]
            SOCKET_PROXY[Docker Socket Proxy]
        end

        DS[Docker Socket]
    end

    %% Connections

    %% External Access
    EXT --> CF
    CF --> CF_TUNNEL
    CF_TUNNEL --> CADDY_EXT

    %% External Service Routing
    CADDY_EXT --> IMMICH_PROXY
    IMMICH_PROXY --> IMMICH
    CADDY_EXT --> PLAUSIBLE

    %% Internal Access
    INT --> TAILSCALE
    TAILSCALE --> CADDY_INT

    %% Internal Service Routing
    CADDY_INT --> ERROR_PAGES
    CADDY_INT --> IMMICH
    CADDY_INT --> PLAUSIBLE
    CADDY_INT --> HOMEPAGE
    CADDY_INT --> POCKET_ID
    CADDY_INT --> GOTIFY
    CADDY_INT --> HEALTHCHECKS
    CADDY_INT --> UPTIME_KUMA
    CADDY_INT --> STIRLING
    CADDY_INT --> MAZANOKE
    CADDY_INT --> CONVERTX
    CADDY_INT --> IT_TOOLS
    CADDY_INT --> SPOTIFY
    CADDY_INT --> PORTAINER
    CADDY_INT --> BESZEL_HUB
    CADDY_INT --> TINYAUTH

    %% Service Dependencies
    BESZEL_HUB --> BESZEL_AGENT
    CADDY_INT --> SOCKET_PROXY
    TINYAUTH --> SOCKET_PROXY
    DIUN --> SOCKET_PROXY
    BESZEL_AGENT --> SOCKET_PROXY
    PORTAINER --> DS
    SOCKET_PROXY --> DS

    %% Styling
    classDef external fill:#ffe66d,stroke:#ffc107,stroke-width:2px,color:#000
    classDef internal fill:#a8e6cf,stroke:#66bb6a,stroke-width:2px,color:#000
    classDef user-services fill:#42a5f5,stroke:#1976d2,stroke-width:2px,color:#fff
    classDef infra-services fill:#ba68c8,stroke:#9c27b0,stroke-width:2px,color:#fff

    class CF,CF_TUNNEL,IMMICH_PROXY,CADDY_EXT external
    class TAILSCALE,CADDY_INT,ERROR_PAGES internal
    class IMMICH,PLAUSIBLE,HOMEPAGE,PORTAINER,BESZEL_HUB,POCKET_ID,GOTIFY,HEALTHCHECKS,UPTIME_KUMA,STIRLING,MAZANOKE,CONVERTX,IT_TOOLS,SPOTIFY,TINYAUTH user-services
    class SOCKET_PROXY,BESZEL_AGENT,DIUN infra-services
```

## Services

### [Portainer](./portainer/)

[Portainer](https://portainer.io/) is a lightweight management UI that allows you to easily manage your Docker containers, images, networks, and volumes. I use it to deploy and manage my self-hosted services, using the GitOps feature to automatically deploy changes to my services when I push to this repository. I also run a Portainer agent on my ODROID N2+ to manage the staging environment.

### [Caddy](./caddy/)

I use [Caddy](https://caddyserver.com/) as the reverse proxy for my services due to its robust feature set and ease of use. I use a custom build that includes the [Caddy-Docker-Proxy](https://github.com/lucaslorentz/caddy-docker-proxy) and [Cloudflare DNS](https://github.com/caddy-dns/cloudflare) plugins for label-based configuration and automatic SSL certificate management.

I also use [Error Pages](https://github.com/tarampampam/error-pages) to provide custom error pages for my services, resulting in more user-friendly error information.

### [Beszel](./beszel/)

[Beszel](https://beszel.dev/) is a lightweight server monitoring platform that includes Docker statistics, historical data, and alert functions. I use it as the main monitoring tool for my homelab, providing insights into the performance and health of my machines.

### [Pocket ID](./pocket-id/)

My authentication service of choice is [Pocket ID](https://pocket-id.org/). It is a self-hosted identity provider that supports OpenID Connect and OAuth 2.0, allowing me to manage user authentication and authorization for my applications securely. I chose it for its simplicity, clean UI, ease of integration, and focus on passwordless authentication.

### [Tinyauth](./tinyauth/)

[Tinyauth](https://tinyauth.app) is an application that enables authentication in front of services that do not natively support it. For my use case specifically, it allows me to use Tinyauth as an authentication proxy for Pocket ID with Caddy. This means I can protect any service behind Caddy with Pocket ID authentication, and even provide OAuth account functionality to some services through user headers, such as [Healthchecks](#healthchecks).

### [Diun](./diun/)

[Docker Image Update Notifier (Diun)](https://crazymax.dev/diun/) is an application for receiving notifications when a Docker image is updated on a Docker registry. I use it to monitor my important containers and notify me via 3rd-party integrations when a new image version is found.

### [Homepage](./homepage/)

I use [Homepage](https://gethomepage.dev/) as the central dashboard for my homelab. It provides a customizable and user-friendly interface to access and manage all my services in one place.

### [Uptime Kuma](./uptime-kuma/)

To monitor the uptime of my services, I use [Uptime Kuma](https://github.com/louislam/uptime-kuma). It is a feature-rich monitoring tool that supports various check types, has many notification options, and has a status page builder.

### [Healthchecks](./healthchecks/)

[Healthchecks](https://healthchecks.io/) is a cron job and background task monitoring service. It allows you to create "check-ins" for your scheduled tasks, and if a task fails to check in within a specified time frame, it sends you an alert via email or other notification methods. I use it to monitor various scheduled tasks and ensure they are running as expected.

### [Docker Socket Proxy](./socket-proxy/)

Due to some services' reliance on connection to the docker socket, I use [Docker Socket Proxy](https://github.com/wollomatic/socket-proxy) to securely expose the Docker API to my services in read-only mode without giving them direct access to the Docker daemon (with the exception of Portainer, which requires full access).

### [Immich](./immich/)

[Immich](https://immich.app/) is a self-hosted photo and video storage solution with functionality similar to Google Photos. It allows you to automatically back up your photos and videos from your devices, providing a web interface to view and manage your media. It is my primary photo and video management solution.

I also run [Immich Public Proxy](https://github.com/alangrainger/immich-public-proxy) to provide secure external access to link shares and public albums without exposing the main Immich server directly to the internet.

### [Cloudflared](./cloudflared/)

To facilitate secure public access to a subset of my services, I use [Cloudflared](https://github.com/cloudflare/cloudflared) to create secure tunnels to my internal services. This allows me to expose specific services to the internet without exposing my entire network.

### [Plausible](./plausible/)

[Plausible](https://plausible.io/) is a web analytics tool that is privacy-friendly and compliant with GDPR. It provides insights into website traffic without compromising user privacy. I use it to track and analyze the traffic to my internal and external services.

### [Stirling PDF](./stirling-pdf/)

I use [Stirling PDF](https://www.stirlingpdf.com/) for all my PDF needs. It is a self-hosted tool that allows you to merge, split, and manipulate PDF files easily without giving up your privacy.

### [Spotify Dashboard](./spotify-dashboard/)

[Spotify Dashboard](https://github.com/Yooooomi/your_spotify) is purely for displaying historical listening data. It is not a replacement for the Spotify app, but rather a nice tool to visualize your listening habits and statistics over time.

### [Mazanoke](./mazanoke/)

I run [Mazanoke](https://mazanoke.com/) for easy photo compression and conversion. It provides a clean web interface and runs completely in the browser, making it a convenient tool for quick image processing tasks.

### [ConvertX](./convertx/)

[ConvertX](https://github.com/C4illin/ConvertX) is a file conversion service that allows you to convert various file types easily from a simple web interface.

### [IT Tools](./it-tools/)

[IT Tools](https://github.com/sharevb/it-tools) is a collection of useful tools for IT professionals and software developers, including key generators, network tools, cheat sheets, and more.
