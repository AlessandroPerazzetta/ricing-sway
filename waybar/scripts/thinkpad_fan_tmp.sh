#!/usr/bin/env bash
# Print CPU temp and first fan speed

# Adjust grep and awk to match your hardware output!
cpu=$(sensors | awk '/Core 0/ {print $3}' | head -n 1)
fan=$(sensors | awk '/fan1/ {print $2 " RPM"}' | head -n 1)

if [[ -n "$cpu" && -n "$fan" ]]; then
  echo " $cpu $fan"
else
  echo "No data"
fi
