#!/bin/ksh
# lacp_tcpdump.sh — Capture LACP packets on AIX using tcpdump
#
# Usage: ./lacp_tcpdump.sh <interface> [duration_seconds]
#
# Example1:  ./lacp_tcpdump.sh en2
# Example2:  ./lacp_tcpdump.sh en2 120
#
# EtherType 0x8809 = Slow Protocols (LACP, MARKER)
# -C 5  = rotate file every 5MB
# -s 0  = full packet capture, no truncation
# -vvv  = maximum verbosity, decodes LACP PDU fields
#
# Author: Saania Khanna — github.com/bysaania/aix-sysadmin-toolkit

INTERFACE=$1
DURATION=${2:-60}
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTFILE="/tmp/lacp_${INTERFACE}_${TIMESTAMP}.cap"

if [ -z "$INTERFACE" ]; then
    echo "Error: Please specify an interface name"
    echo "Usage: $0 <interface> [duration_seconds]"
    echo "Example1:  $0 en2"
    echo "Example2:  $0 en2 120"
    exit 1
fi

cleanup() {
    echo ""
    echo "tcpdump stopped. Cap file: $OUTFILE"
    [ -n "$TCPDUMP_PID" ] && kill "$TCPDUMP_PID" 2>/dev/null
    exit 0
}
trap cleanup INT TERM

echo "Starting tcpdump for ${DURATION}s on $INTERFACE — output: $OUTFILE"

tcpdump -C 5 -w "$OUTFILE" -s 0 -i "$INTERFACE" 'ether proto 0x8809' &
TCPDUMP_PID=$!

sleep "$DURATION"
kill "$TCPDUMP_PID" 2>/dev/null
wait "$TCPDUMP_PID" 2>/dev/null

echo "tcpdump capture complete — $OUTFILE"
echo "To analyze: tcpdump -r $OUTFILE -vvv"
