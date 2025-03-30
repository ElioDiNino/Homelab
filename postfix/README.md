# Postfix Configuration

This directory contains configuration files for the [Postfix](http://www.postfix.org/) mail server. I use Postfix to send emails programmatically via the configured [ForwardEmail](https://forwardemail.net) relay.

## Configuration Files

For Debian-based systems, the configuration files are located in the `/etc/postfix` directory. The following is a list of my configuration files:

- `main.cf`: The main configuration file for Postfix.
- `sasl_passwd`: Contains the credentials for the SMTP relay.
- `sender_canonical_maps`: Changes the sender address to a specified address.
- `smtp_header_checks`: Rewrites the SMTP from address to a specified address.

### Applying Changes

After making changes to the configuration files, the following commands must be run to apply them:

```bash
postmap /etc/postfix/sasl_passwd
postfix reload
```

## Resources

- [Postfix Basic Configuration](http://www.postfix.org/BASIC_CONFIGURATION_README.html)
- [Proxmox SMTP Relay Tutorial](https://forum.proxmox.com/threads/get-postfix-to-send-notifications-email-externally.59940/)
