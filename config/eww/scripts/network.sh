#!/usr/bin/env bash
if command -v nmcli >/dev/null 2>&1; then
  ssid="$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2; exit}')"
  if [[ -n "$ssid" ]]; then
    echo "$ssid"
    exit 0
  fi
  dev="$(nmcli -t -f device,type,state dev 2>/dev/null | awk -F: '$2=="ethernet" && $3=="connected"{print $1; exit}')"
  if [[ -n "$dev" ]]; then
    echo "eth"
    exit 0
  fi
fi
echo "offline"
