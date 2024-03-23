#!/bin/bash

# Tunnel RDP Access
TUNNEL_RDP="0"

#Audio forward
USE_AUDIO="0"
#Use Multiple Monitors
USE_MULTIMON="0"

# Get user inputs
DST_IP_PORT="${1}"
IP="${DST_IP_PORT%%:*}"
PORT="${DST_IP_PORT#*:}"
USR_NAME="${2}"
USR_PASSWD="${3}"

# Log the process in /var/log/syslog
THIS_PROCESS="${BASHPID}"
TAG="windows_rdp"
if [[ -t 1 ]]; then
    exec 1> >( exec logger --id=${THIS_PROCESS} -s -t "${TAG}" ) 2>&1
else
    exec 1> >( exec logger --id=${THIS_PROCESS} -t "${TAG}" ) 2>&1
fi

# Parse command-line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --audio)
            USE_AUDIO="1"
            ;;
        --multimon)
            USE_MULTIMON="1"
            ;;
    esac
    shift
done

TUNNEL () {
    [ "${TUNNEL_RDP}" != "1" ] && return
    ssh -o ExitOnForwardFailure=yes -f -L "${PORT}":"127.0.0.1":"${PORT}" "${USR_NAME}"@"${IP}" -i /home/lx-01/.ssh/nocixopenssh  whoami;
}

DO_RDP () {
    EXEC=(xfreerdp)
    EXEC+=(/u:"${USR_NAME}")
    EXEC+=(/p:"${USR_PASSWD}")
    EXEC+=(/v:"${DST_IP_PORT}")
    EXEC+=(/wm-class:RDP)
    EXEC+=(/dynamic-resolution)
    EXEC+=(/gfx)
    EXEC+=(+gfx-progressive)
    EXEC+=(+gfx-small-cache)
    EXEC+=(/compression-level:2)
    EXEC+=(/log-level:ERROR)
    EXEC+=(/clipboard)
    # Enable audio and mic if specified
    [ "${USE_AUDIO}" == "1" ] && EXEC+=(/audio) && EXEC+=(/microphone)
    # Enable multimonitor support if specified
    [ "${USE_MULTIMON}" == "1" ] && EXEC+=(/multimon)
    EXEC+=(+auto-reconnect)
    EXEC+=(/auto-reconnect-max-retries:3)
    EXEC+=(-themes)
    EXEC+=(-wallpaper)
    exec "${EXEC[@]}"
}

MAIN () {
    TUNNEL
    DO_RDP
}

MAIN