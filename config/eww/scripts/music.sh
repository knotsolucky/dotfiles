#!/usr/bin/env bash
set -euo pipefail

status="$(playerctl status 2>/dev/null || true)"

if [[ -z "$status" || "$status" == "Stopped" ]]; then
  echo "no media"
  exit 0
fi

artist="$(playerctl metadata artist 2>/dev/null || true)"
title="$(playerctl metadata title 2>/dev/null || true)"

if [[ -z "$artist$title" ]]; then
  echo "${status,,}"
  exit 0
fi

if [[ -n "$artist" && -n "$title" ]]; then
  echo "$artist - $title"
elif [[ -n "$title" ]]; then
  echo "$title"
else
  echo "$artist"
fi
