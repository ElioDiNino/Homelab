#!/bin/bash

# Updates Tailscale certs on Proxmox nodes
# Based on https://tailscale.com/kb/1133/proxmox

HEALTHCHECKS_DOMAIN="healthchecks.example.com"  # Change to your Healthchecks ping domain
UUID="your-uuid-here"  # Change to your Healthchecks check UUID

# Ping Healthchecks (start)
curl -m 10 --retry 5 -s -S https://${HEALTHCHECKS_DOMAIN}/ping/${UUID}/start

cd ~  # Put the certs in the home directory
NAME="$(tailscale status --json | jq '.Self.DNSName | .[:-1]' -r)"
m=$(tailscale cert "${NAME}" 2>&1)
m+=$(pvenode cert set "${NAME}.crt" "${NAME}.key" --force --restart 2>&1)
e="$?"
echo "$m"

# Ping Healthchecks (with exit code)
curl -m 10 --retry 5 -s -S --data-raw "$m" https://${HEALTHCHECKS_DOMAIN}/ping/${UUID}/$e
