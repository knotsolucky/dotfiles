# Starship

**Canonical config:** [`config/starship.toml`](../config/starship.toml) → **`~/.config/starship.toml`**.

[`home/.zshrc`](../home/.zshrc) and [`macos/.zshrc`](../macos/.zshrc) set **`export STARSHIP_CONFIG="${STARSHIP_CONFIG:-…/starship.toml}"`** **before** **`starship init zsh`**. If **`STARSHIP_CONFIG`** was set **after** init (old `home/.zshrc`), the first init used the wrong file; if it forced **`…/starship/starship.toml`**, a nested **`zsh`** re-sourced that line and the prompt jumped from the rich default (after **`unset STARSHIP_CONFIG`**) back to the minimal look.

Optional minimal prompt: keep [`config/starship/starship.toml`](../config/starship/starship.toml) and **`export STARSHIP_CONFIG=…/starship/starship.toml`** in **`~/.zshenv`** (or only when you want it), not in the shared `.zshrc` unless you prefer that file.

The bad merge on **`starship.toml`** ( **`error_symbol`** glued to **`add_newline`** ) is fixed in-repo.
