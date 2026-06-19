#!/bin/ksh
# iperf_client.sh — Run iperf in client mode on AIX
#
# Usage: ./iperf_client.sh <server_ip> [port]
#
# Example1:  ./iperf_client.sh 9.40.205.38
# Example2:  ./iperf_client.sh 9.40.205.38 5002
#            (use Example2 only if port 5001 is blocked or a specific port is needed)
#
# Defaults:
#   Protocol    : TCP
#   Port        : 5001 (iperf default)
#   Duration    : 30 seconds per run
#   Buffer len  : 64k
#   Interval    : 1 second reports
#
# Author: Saania Khanna — github.com/bysaania/aix-sysadmin-toolkit

SERVER=$1
PORT=${2:-5001}
DURATION=30
LENGTH="64k"
INTERVAL=1
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOGFILE="/tmp/iperf_client_${TIMESTAMP}.log"

if [ -z "$SERVER" ]; then
    echo "Error: Please specify the server IP address"
    echo "Usage: $0 <server_ip> [port]"
    echo "Example1:  $0 9.40.205.38"
    echo "Example2:  $0 9.40.205.38 5002"
    exit 1
fi

# Prompt for window size
echo "Enter TCP window size (default 512k, e.g. 256k / 512k / 1m): "
read INPUT_WINDOW
WINDOW=${INPUT_WINDOW:-512k}

echo "" | tee $LOGFILE
echo "iperf client — $SERVER:$PORT" | tee -a $LOGFILE
echo "Window: $WINDOW  Duration: ${DURATION}s per run" | tee -a $LOGFILE
echo "Log file: $LOGFILE" | tee -a $LOGFILE

# ---------------------------------------------------------------------------
# Run loop — prompts for parallel thread count before each run
# Enter 0 or leave blank to stop
# ---------------------------------------------------------------------------
while true; do
    echo "" | tee -a $LOGFILE
    echo "Enter number of parallel threads to run (e.g. 1 / 5 / 10), or 0 to exit: "
    read INPUT_PARALLEL

    # Exit if user enters 0 or just hits Enter
    case "$INPUT_PARALLEL" in
        0|"") echo "Done. Log saved to $LOGFILE"; break ;;
    esac

    echo "" | tee -a $LOGFILE
    echo "-- Running with -P $INPUT_PARALLEL threads --" | tee -a $LOGFILE
    echo "$(date '+%Y-%m-%d %H:%M:%S')" | tee -a $LOGFILE

    iperf -c $SERVER \
          -p $PORT \
          -t $DURATION \
          -P $INPUT_PARALLEL \
          -l $LENGTH \
          -w $WINDOW \
          -i $INTERVAL | tee -a $LOGFILE

    echo "" | tee -a $LOGFILE
    echo "-- Run complete --" | tee -a $LOGFILE
done
