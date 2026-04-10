#!/usr/bin/env bash
set -euo pipefail

read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle1=$((idle + iowait))
sleep 0.2
read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle2=$((idle + iowait))

delta_total=$((total2 - total1))
delta_idle=$((idle2 - idle1))

if (( delta_total <= 0 )); then
  echo "0%"
  exit 0
fi

usage=$(( (100 * (delta_total - delta_idle)) / delta_total ))
echo "${usage}%"
