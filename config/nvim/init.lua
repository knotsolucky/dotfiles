local data = vim.fn.stdpath("data")
vim.env.PATH = table.concat({
  data .. "/mason/bin",
  "/usr/local/bin",
  "/usr/bin",
  "/bin",
  vim.env.PATH or "",
}, ":")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")

local lazypath = data .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins.theme" },
  { import = "plugins.dashboard" },
  { import = "plugins.mason" },
  { import = "plugins.treesitter" },
  { import = "plugins.whichkey" },
  { import = "plugins.lsp" },
  { import = "plugins.format" },
  { import = "plugins.lint" },
  { import = "plugins.dap" },
  { import = "plugins.extras" },
}, require("config.lazy"))

require("config.keymaps")
