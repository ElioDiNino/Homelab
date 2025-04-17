# Network UPS Tools Configuration

This directory contains configuration files for the [Network UPS Tools (NUT)](https://networkupstools.org) service which I use to monitor and manage the UPS attached to my server.

## Configuration Files

For Debian-based systems, the configuration files are located in the `/etc/nut` directory. The following is a list of my configuration files:

- `nut.conf`: The main configuration file for NUT.
- `ups.conf`: The configuration file for the UPS devices.
- `heartbeat.conf`: The configuration file for the NUT heartbeat.
- `upsd.users`: The configuration file for the NUT users.
- `upsmon.conf`: The configuration file for the NUT monitor.
- `upsd.conf`: The configuration file for the NUT server.
- `upssched.conf`: The configuration file for the NUT scheduler.
- `upssched-cmd.sh`: The script that is executed by the NUT scheduler.

### Applying Changes

After making changes to the configuration files, the following commands must be run to apply them:

```bash
service nut-server restart
service nut-client restart
systemctl restart nut-monitor
upsdrvctl stop
upsdrvctl start
```

## Resources

- [NUT Documentation](https://networkupstools.org/docs/user-manual.chunked/index.html)
- [Configuration Examples](https://rogerprice.org/NUT/ConfigExamples.A5.pdf)
