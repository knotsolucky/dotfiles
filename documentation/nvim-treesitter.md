# nvim-treesitter

- Lazy spec matches [upstream quickstart](https://github.com/nvim-treesitter/nvim-treesitter) (`lazy = false`, `build = ":TSUpdate"`). No `setup()` — defaults are enough.
- Small `FileType` autocmd calls `vim.treesitter.start()` as in `:h treesitter-highlight`.
- Install parsers with `:TSInstall <lang>` or `:TSInstall all` when needed.
