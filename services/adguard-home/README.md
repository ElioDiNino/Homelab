# AdGuard Home Configuration

This directory contains the [Docker Compose configuration](./compose.yaml) for [AdGuard Home](https://adguard.com/en/adguard-home/overview.html). AdGuard Home has no environment variable configuration and rewrites `AdGuardHome.yaml` at runtime, so it is configured through its web interface and config file rather than being fully declared here.

## Host Prerequisites

The container binds port `53` on the host, which collides with the `systemd-resolved` stub listener on Ubuntu/Debian that holds `127.0.0.53` and `127.0.0.54`. Each step below must be completed one after the other.

### Tailscale

Stop Tailscale from managing DNS on the host:

```sh
sudo tailscale set --accept-dns=false
```

Tailscale treats an `/etc/resolv.conf` whose nameservers are not exactly `127.0.0.53` as evidence that `systemd-resolved` is not in use. Left alone, it would fall back to managing the file itself and overwrite the configuration below. We give up resolving MagicDNS names on this host as a result, which is fine because containers cannot use them either.

### systemd-resolved

Disable the stub listener rather than the service itself, since `/etc/resolv.conf` is a symlink into a runtime directory that disappears along with it, leaving the host with no resolver at all:

```sh
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo tee /etc/systemd/resolved.conf.d/adguardhome.conf > /dev/null <<'EOF'
[Resolve]
DNS=1.1.1.1 1.0.0.1
DNSStubListener=no
EOF
sudo mv /etc/resolv.conf /etc/resolv.conf.backup
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo systemctl reload-or-restart systemd-resolved
```

The stub listener is also what answers for the host's own hostname, which `systemd-resolved` synthesizes rather than reading from anywhere on disk. Without it, commands that resolve the local hostname fail with `unable to resolve host <hostname>`, so make sure it is in `/etc/hosts`:

```sh
grep -q "$(hostnamectl --static)" /etc/hosts || \
  echo "127.0.1.1 $(hostnamectl --static)" | sudo tee -a /etc/hosts
```

The symlink has to be swapped because `stub-resolv.conf` lists the now-disabled `127.0.0.53` as its only nameserver. `/run/systemd/resolve/resolv.conf` lists the upstream servers directly instead.

[AdGuard Home's own instructions](https://github.com/AdguardTeam/AdGuardHome/wiki/Docker#resolved-daemon) use `DNS=127.0.0.1` here so that the host resolves through AdGuard Home. That is deliberately avoided: it would leave the host unable to resolve anything while the container is stopped, including the registry it pulls the image from.

## Setup

After the first launch:

1. Open `https://dns.<internal domain>` and complete the setup wizard, leaving the **admin web interface** on port `3000` and the **DNS server** on port `53`. The credentials must match `ADGUARD_USERNAME` and `ADGUARD_PASSWORD`, which [Tinyauth](../tinyauth/) reads in order to sign in on a user's behalf and the [Homepage](../homepage/) widget uses to query stats directly.
2. Stop the container, since a running AdGuard Home overwrites edits to its config file, and set the following in `AdGuardHome.yaml` in the `conf` volume:

   ```yaml
   http:
     doh:
       insecure_enabled: true # Serve DoH over plain HTTP behind Caddy
   dns:
     trusted_proxies:
       - 172.16.0.0/12 # Honour X-Forwarded-For from Caddy so DoH queries are attributed to the real client
   ```

3. Start the container again.

## Clients

Plain DNS is available on port `53` of the host and DNS-over-HTTPS at `https://dns.<internal domain>/dns-query`, which [Caddy](../caddy/) terminates using its existing wildcard certificate. Since Caddy already serves HTTP/3, DoH clients get QUIC transport without AdGuard Home needing a certificate of its own. DNS-over-TLS and DNS-over-QUIC are not offered, as both would require giving AdGuard Home its own copy of that certificate.

Devices can be pointed at the host either through Tailscale's global nameserver setting or over the LAN. Note that configuring the router to forward its own DNS to AdGuard Home makes every LAN query arrive from the router and loses per-client attribution, whereas handing out the host's address to clients directly over DHCP preserves it.

## LAN Access

Service subdomains resolve publicly to the host's Tailscale address, which devices on the router's network cannot reach without joining the tailnet. Answering with the host's LAN address instead lets them reach [Caddy](../caddy/) directly over the LAN.

A global DNS rewrite would apply that answer to every client, including remote Tailscale devices that need the Tailscale address, so this is done with a scoped rule under **Filters → Custom filtering rules**:

```adblock
|*.<internal domain>^$dnsrewrite=NOERROR;A;<LAN address of the Docker host>,client=<LAN subnet>
```

LAN clients match and get the LAN address. Tailscale clients query from `100.64.0.0/10`, do not match, and fall through to the upstream answer, so they keep working from anywhere. `$dnsrewrite` rules take priority over all other rules.

The pattern matches subdomains at any depth but never the apex, which is important because the apex is the public landing page rather than something this host serves. `|` anchors the start of the hostname, so although `*` can match an empty string, the leading dot is still required.

Certificates are unaffected. Only the address the name resolves to changes, so Caddy answers for the same hostname and serves its existing wildcard certificate.

Client matching also works for DNS-over-HTTPS, since `trusted_proxies` lets AdGuard Home read the real client address out of Caddy's `X-Forwarded-For` rather than attributing every encrypted query to the proxy.

If the wildcard DNS record also has an `AAAA`, dual-stack LAN clients may still prefer the unreachable Tailscale IPv6 address. A second rule returns an empty answer for `AAAA` so that they fall back to IPv4:

```adblock
|*.<internal domain>^$dnsrewrite=NOERROR;;,dnstype=AAAA,client=<LAN subnet>
```

## Resources

- [AdGuard Home Knowledge Base](https://adguard-dns.io/kb/adguard-home/overview/)
- [Configuration file reference](https://adguard-dns.io/kb/adguard-home/configuration/)
- [Docker guide](https://adguard-dns.io/kb/adguard-home/docker/)
