# nvim-treesitter and `tree-sitter build`

## Symptom

Install / `:TSUpdate` logs errors like:

- `The subcommand 'build' wasn't recognized`
- `Did you mean 'build-wasm'?`

## Cause

Current `nvim-treesitter` compiles parsers with **`tree-sitter build`** and expects **tree-sitter CLI ≥ 0.26.1** (see `:checkhealth nvim-treesitter`).

Neovim resolves `tree-sitter` from **`PATH`**. If an **older** CLI is found first (common locations: `~/.cargo/bin`, Mason `.../mason/bin`, `/usr/local/bin` from Homebrew or manual install), that binary may not implement `build`.

## Fix in this repo

1. `config/nvim/init.lua` builds a sane base `PATH` (system dirs before Mason).
2. `config/nvim/lua/config/treesitter_cli.lua` scans known locations plus your existing `PATH`, picks the **newest** `tree-sitter` whose version is **>= 0.26.1**, and **prepends that binary’s directory** so nvim-treesitter never calls an older shim by accident.

After changing PATH or upgrading the CLI:

1. `:checkhealth nvim-treesitter` — confirm CLI version and path.
2. `:TSInstall! lua` (or `:TSUpdate`) — force reinstall parsers.

## If it still fails

- Inspect which binary Neovim uses: `:echo exepath('tree-sitter')` then run that path with `--help` and confirm `build` exists.
- Upgrade or remove the bad shim: `pacman -S tree-sitter` (Arch), `brew upgrade tree-sitter`, or `cargo install tree-sitter-cli --locked --force`.
