#!/usr/bin/env bash
hyprctl activewindow -j 2>/dev/null | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    t = (d.get('title') or d.get('class') or '').strip()
    print(t[:80] if t else '—')
except Exception:
    print('—')
" 2>/dev/null || echo "—"
