Optional shell hooks: drop executable `*.sh` here; `theme-switch` (app appearance only) runs each with one argument: `dark` or `light`.

Example `99-cursor.sh`:

```sh
#!/usr/bin/env sh
# merge workbench.colorTheme in Cursor — install jq
case "$1" in
  light) theme="Default Light Modern" ;;
  *) theme="Default Dark Modern" ;;
esac
jq --arg t "$theme" '. + { "workbench.colorTheme": $t }' \
  "$HOME/.config/Cursor/User/settings.json" > /tmp/cursor-settings.json \
  && mv /tmp/cursor-settings.json "$HOME/.config/Cursor/User/settings.json"
```

Restart or reload the target app if needed.
