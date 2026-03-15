#!/bin/ksh
# netstat_loop.sh — Continuous network stats collector for AIX support cases
# Usage: ./netstat_loop.sh [interval_seconds]
# Stop:  Ctrl+C or kill <PID>

INTERVAL=${1:-3}
OUTFILE="/tmp/ibmsupt/testcase/netstat.out"

mkdir -p $(dirname $OUTFILE)

echo "[$0] Started — writing to $OUTFILE every ${INTERVAL}s (PID: $$)"
echo "[$0] Stop with: kill $$"

while true; do
    echo "\n======= $(date) =======" >> $OUTFILE

    netstat -v | egrep -i \
        'ETHERNET STAT|Elapsed|No Resource Errors|Hypervisor Receive Failures|Receive Q No Buffers' \
        >> $OUTFILE

    echo "\n----- UDP -----" >> $OUTFILE
    netstat -p udp >> $OUTFILE

    echo "\n----- ICMP -----" >> $OUTFILE
    netstat -p icmp >> $OUTFILE

    sleep $INTERVAL
done
