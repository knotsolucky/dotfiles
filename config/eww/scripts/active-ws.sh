#!/usr/bin/env bash
# hyprsplit: use workspace name (slot 1–10) for bar highlight; id is global and differs per head.
hyprctl activeworkspace -j 2>/dev/null | python3 -c "
import sys, json
try:
    j = json.load(sys.stdin)
    n = j.get('name')
    if n is not None and str(n).strip() != '':
        print(str(n).strip(), end='')
    else:
        print(j.get('id', 1), end='')
except Exception:
    print('1', end='')
"
