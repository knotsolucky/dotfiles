# Neovim in this repo

## `vim.uv` vs `vim.loop`

Neovim **0.10+** exposes **`vim.uv`** (libuv). **0.9.x** (e.g. Ubuntu **noble** `neovim` package) only has **`vim.loop`**.

[`config/nvim/init.lua`](../config/nvim/init.lua) uses **`local uv = vim.uv or vim.loop`** before **`fs_stat`** so lazy.nvim bootstrap works on both.

## `vim.fs.joinpath`

**Neovim 0.10+** adds **`vim.fs.joinpath`**. **0.9.x** lacks it; newer **nvim-treesitter** calls it during setup. **`init.lua`** defines a small **`joinpath`** polyfill when **`vim.fs`** exists but **`joinpath`** is missing.
