#!/bin/bash

while true; do
  SECONDS=$1 # Everytime the next line is executed, SECONDS get doubled, so I need to reset it
  sleep $SECONDS # Everytime 
  if [[ -z "$(who -q | grep -m1 users=1)" ]]; then
    echo "No SSH clients after ${1} seconds. Stopping the container..."
    ps x -o pid h | xargs kill &>/dev/null
  fi
done 
