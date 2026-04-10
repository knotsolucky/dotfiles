#!/usr/bin/env bash
line="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)" || { echo "—"; exit 0; }
if [[ "$line" == *MUTED* ]]; then
  echo "mute"
  exit 0
fi
# Volume: 0.40
pct="$(printf '%s\n' "$line" | sed -n 's/.*Volume:[[:space:]]*\([0-9.]*\).*/\1/p')"
[[ -z "$pct" ]] && { echo "—"; exit 0; }
python3 -c "print(str(int(round(float('${pct}')*100)))+'%')"
