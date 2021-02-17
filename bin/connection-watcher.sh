#!/bin/bash
SLEEP_FOR=${1:-5}
while sleep ${SLEEP_FOR}; do
  if [[ -z "$(who -q | grep -m1 users=1)" ]]; then
    echo "No SSH clients after ${SLEEP_FOR} seconds. Stopping the container..."
    ps x -o pid h | xargs kill &>/dev/null
  fi
done 
