#!/usr/bin/env bash
set -euo pipefail
status="$(playerctl status 2>/dev/null || true)"
if [[ -z "$status" || "$status" == "Stopped" ]]; then
  echo "—"
  exit 0
fi
artist="$(playerctl metadata artist 2>/dev/null || true)"
title="$(playerctl metadata title 2>/dev/null || true)"
if [[ -n "$artist" && -n "$title" ]]; then
  line="$artist — $title"
elif [[ -n "$title" ]]; then
  line="$title"
elif [[ -n "$artist" ]]; then
  line="$artist"
else
  line="$status"
fi
if ((${#line} > 72)); then
  line="${line:0:69}…"
fi
printf '%s\n' "$line"
