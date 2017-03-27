#!/bin/bash

# This is a bash script for wrapping the salt-minion, so the bash script
# is PID 1.
#
# It avoids zombie salt-minion processes because bash implements basic
# signal handling. It will also perform a cleanup when the process dies,
# and waits for 5 seconds. Far than ideal.
#
# We could also use dumb-init if this proves not to be enough:
#   - https://github.com/Yelp/dumb-init

function cleanup() {
  local pids=`jobs -p`
  if [ "$pids" != "" ]; then
    kill $pids >/dev/null 2>/dev/null
    sleep 5
  fi
}

trap cleanup EXIT
/usr/bin/salt-minion
