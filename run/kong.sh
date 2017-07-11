#!/bin/bash

set -e

source /etc/environment

DAEMON=kong
ARGS="start --vv"

# Verify if process is already running
if [ -e /var/run/$DAEMON.pid ]; then
	# Kill process and remove PID file
	PID=`cat /var/run/$DAEMON.pid`
  rm /var/run/$DAEMON.pid
  kill $PID
fi

while ! nc -q 1 $KONG_PG_HOST 5432 </dev/null; do
	echo "Waiting $KONG_PG_HOST..."
	sleep 5
done

# Start process and save PID
nohup $DAEMON $ARGS 1>/var/log/$DAEMON.out 2>/var/log/$DAEMON.err &
echo $! > /var/run/$DAEMON.pid

exit 0
