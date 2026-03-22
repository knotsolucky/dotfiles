#!/usr/bin/env bash
# Small distro logo (above) + Unicode frame around fastfetch lines.
# fetch-card.jsonc uses logo: null and key width 0 so rows are plain (no cursor jumps).
set -euo pipefail
CARD_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch/fetch-card.jsonc"
C_LINE=$'\033[36m'
C_RST=$'\033[0m'

# Strip CSI sequences for measuring display width (colors + cursor motion).
strip_csi() {
  perl -pe 's/\e\[[0-9;:]*[A-Za-z]//g; s/\e\]133[^\x07]*\x07//g'
}

# --pipe false: keep ANSI so keys/title stay colored in Kitty (stdout is not a TTY here).
mapfile -t lines < <(fastfetch --pipe false --config "$CARD_CFG" --logo none)

width=0
declare -a plain
for l in "${lines[@]}"; do
  p=$(printf '%s' "$l" | strip_csi)
  ((${#p} > width)) && width=${#p}
  plain+=("$p")
done

# Inner span between corners = " " + content(width) + " " → width + 2 dashes.
hor=$((width + 2))
top="${C_LINE}╭"
bottom="${C_LINE}╰"
for ((i = 0; i < hor; i++)); do
  top+="─"
  bottom+="─"
done
top+="╮${C_RST}"
bottom+="╯${C_RST}"

box_outer=$((width + 4))

mapfile -t logo_lines < <(fastfetch --pipe false -s logo --logo-type small 2>&1 | strip_csi)
while ((${#logo_lines[@]} > 0)) && [[ -z ${logo_lines[-1]} ]]; do
  unset 'logo_lines[-1]'
done

for l in "${logo_lines[@]}"; do
  [[ -z $l ]] && continue
  ((padl = (box_outer - ${#l}) / 2))
  ((padl < 0)) && padl=0
  printf '%*s' "$padl" ''
  printf '%b%s%b\n' "$C_LINE" "$l" "$C_RST"
done
echo

printf '%s\n' "$top"
i=0
for l in "${lines[@]}"; do
  p="${plain[i]}"
  ((pad = width - ${#p}))
  ((pad < 0)) && pad=0
  printf '%b│%s ' "$C_LINE" "$C_RST"
  printf '%s' "$l"
  printf '%*s' "$pad" ''
  printf ' %b│%s\n' "$C_LINE" "$C_RST"
  ((++i)) || true
done
printf '%s\n' "$bottom"
echo
read -n1 -s -r -p 'Press any key to close…'
