#!/bin/sh

set -e

# Verify if APPLICATION_NAME exists, if not exists set default value
if [ -z ${APPLICATION_NAME+x} ]; then
	APPLICATION_NAME=$APPLICATION_DEFAULT_NAME
fi
export APPLICATION_NAME

DAEMON=kong-dashboard
ARGS="start"

# Verify if process is already running
if [ -e /var/run/$DAEMON.pid ]; then
	# Kill process and remove PID file
	PID=`cat /var/run/$DAEMON.pid`
  rm /var/run/$DAEMON.pid
  kill $PID
fi

# Start process and save PID
nohup $DAEMON $ARGS 1>/var/log/$DAEMON.out 2>/var/log/$DAEMON.err &
echo $! > /var/run/$DAEMON.pid

exit 0
