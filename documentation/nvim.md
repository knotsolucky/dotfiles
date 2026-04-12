# Neovim in this repo

## `vim.uv` vs `vim.loop`

Neovim **0.10+** exposes **`vim.uv`** (libuv). **0.9.x** (e.g. Ubuntu **noble** `neovim` package) only has **`vim.loop`**.

[`config/nvim/init.lua`](../config/nvim/init.lua) uses **`local uv = vim.uv or vim.loop`** before **`fs_stat`** so lazy.nvim bootstrap works on both.
