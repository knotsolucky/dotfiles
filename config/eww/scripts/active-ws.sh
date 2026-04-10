#!/usr/bin/env bash
id="$(hyprctl activeworkspace -j 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',1))" 2>/dev/null)"
[[ -z "$id" ]] && id=1
printf '%s' "$id"
