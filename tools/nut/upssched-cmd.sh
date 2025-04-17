#!/bin/bash
set -euo pipefail

EMAIL=$(cat /etc/pve/user.cfg | grep root | awk '{split($0,a,":"); print a[7]}')
PROXMOXHOST=$(uname -n)

UPS="primary"
STATUS=$(upsc "$UPS" ups.status)
CHARGE=$(upsc "$UPS" battery.charge)
CHMSG="[$STATUS]:$CHARGE%"

SUBJECT="Proxmox ($PROXMOXHOST): UPS Warning"
LOGGER_TAG="upssched-cmd"

case $1 in
online)
    MSG="UPS Online ($CHMSG)"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    ;;
onbatt)
    MSG="UPS on battery ($CHMSG)!"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    ;;
lowbatt)
    MSG="Low battery on UPS ($CHMSG)!"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    ;;
shutafter5min)
    MSG="Shutting down after 5 minutes of lost power"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    shutdown
    ;;
fsd)
    MSG="Forced shutdown from UPS ($CHMSG)!"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    ;;
commok)
    MSG="UPS communication established. UPS status is $CHMSG"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    ;;
commbad)
    MSG="UPS communication lost"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    ;;
nocomm)
    MSG="UPS is not reachable"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    ;;
shutdown)
    MSG="Proxmox is shutting down. UPS status is $CHMSG"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    ;;
replbatt)
    MSG="Replace battery on UPS ($CHMSG)!"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    ;;
heartbeat-failure-timer)
    MSG="UPS heartbeat failed! Check NUT configurations."
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    ;;
*)
    MSG="Unrecognized command: $1"
    echo "$MSG" | mailx -s "$SUBJECT" "$EMAIL"
    logger -t "$LOGGER_TAG" "$MSG"
    ;;
esac
