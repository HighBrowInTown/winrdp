#!/bin/bash

#Check if xfreerdp is installed.

#Username and Password
USER_NAME="${1}"
PASSWD="${2}"
ADDR="${3}"
PORT="${4}"
[ "x${PORT}" == "x" ] && PORT="3389"

#xfreerdp options

XFREERDP () {

    rdp=(xfreerdp)
    rdp+=(/u:"${USER_NAME}")
    rdp+=(/p:"${PASSWD}")
    rdp+=(/v:"${ADDR}::${PORT}")
    rdp+=(/dynamic-resolution)
    rdp+=(/log-level:OFF)
    rdp+=(/audio:auto)
    rdp+=(/video)

}

XFREERDP