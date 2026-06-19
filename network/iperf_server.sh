#!/bin/ksh
# iperf_server.sh — Run iperf in server mode on AIX
#
# Usage: ./iperf_server.sh [port]
#
# Example1:  ./iperf_server.sh
# Example2:  ./iperf_server.sh 5002
#
# Defaults:
#   Protocol : TCP
#   Port     : 5001 (iperf default)
#   Window   : 512k
#
# Author: Saania Khanna — github.com/bysaania/aix-sysadmin-toolkit

PORT=${1:-5001}
WINDOW="512k"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOGFILE="/tmp/iperf_server_${TIMESTAMP}.log"

echo "Starting iperf server on port $PORT" | tee $LOGFILE
echo "Waiting for client connection..." | tee -a $LOGFILE
echo "Stop with Ctrl+C" | tee -a $LOGFILE
echo "Log file: $LOGFILE" | tee -a $LOGFILE
echo "" | tee -a $LOGFILE

iperf -s \
      -p $PORT \
      -w $WINDOW | tee -a $LOGFILE
