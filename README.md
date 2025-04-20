# Homelab

This repository serves as the source of truth for my homelab. It includes an architectural overview along with the configurations for my [self-hosted services](./services/) and [accompanying tools](./tools). See the [overview](#overview) below and the documentation in each directory for more information.

## Landing Page ([internal.eliodinino.com](https://internal.eliodinino.com))

This is a simple public landing page that serves as a gateway to my self-hosted services. It does nothing more than ping an internal endpoint to check if you are on the private [Tailscale](#tailscale) network. If you are, it redirects you to the internal services dashboard. If not, it shows a message saying that you are not authorized. I have this mainly so that myself and others on the network (e.g. my family) don't have to remember many different service URLs and so that we get a quick reminder that we need to enable Tailscale if we forgot.

See the corresponding repository [here](https://github.com/ElioDiNino/internal.eliodinino.com).

## Overview

Below is a high-level overview of my homelab setup, including the hardware and software I use.

### Tailscale

I use [Tailscale](https://tailscale.com/) to create a secure mesh VPN between my devices. This allows me to access my homelab services from anywhere without exposing them to the public internet as well as easily ssh into my devices. Tailscale is easy to set up and provides a secure connection without the need for complex firewall rules or port forwarding. I also leverage Tailscale's private IP addresses to proxy requests to my services on my internal subdomain (`internal.eliodinino.com`) such that I get nice service domains without exposing anything publicly (other than a single Tailscale IP address, which is not sensitive).

### NAS with Proxmox

I have a custom-built NAS ([hardware details here](https://ca.pcpartpicker.com/b/DxrD4D)) that serves as the backbone of my homelab. It is equipped with many terabytes of storage and runs [Proxmox](https://proxmox.com/) as the hypervisor. Proxmox is an extremely powerful virtualization platform that I use to manage my virtual machines and containers. It provides a web-based interface for managing resources, networking, and storage.

#### Docker

I run a [Docker](https://docker.com/) VM ([community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker-vm)) within Proxmox to run [my containerized services](./services/). This allows me to easily manage and deploy my services using Docker Compose within [Portainer](https://portainer.io/).

#### Home Assistant OS

I run [Home Assistant OS](https://home-assistant.io/) on a separate VM ([community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=haos-vm)) within Proxmox. This allows me to manage my smart home devices and automations while taking full advantage of the Home Assistant ecosystem (since features are more limited on the Home Assistant Container). I use the [Home Assistant Tailscale add-on](https://github.com/hassio-addons/addon-tailscale) to connect my Home Assistant instance to Tailscale.

#### HexOS

[HexOS](https://hexos.com/) is a NAS operating system that is built on top of [TrueNAS Scale](https://www.truenas.com/truenas-scale/). It is designed to be extremely easy to use and provides a clean interface for managing my storage needs. I run HexOS on a separate VM within Proxmox and use it to manage my storage pools and shares which hook into my VMs and containers. I also use the TrueNAS Scale [Tailscale app](https://www.truenas.com/apps/) to connect HexOS to Tailscale.

### ODROID with Ubuntu

I have an [ODROID N2+](https://wiki.odroid.com/odroid-n2/odroid-n2) running Ubuntu which was where I began my homelab journey. It now serves as a staging environment for the services I run on my NAS through the use of a Portainer agent and the subdomain `staging.internal.eliodinino.com`. This allows me to test and develop new services before deploying them to my production environment.
