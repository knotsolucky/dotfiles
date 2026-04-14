local data = vim.fn.stdpath("data")
vim.env.PATH = table.concat({
  "/usr/bin",
  "/bin",
  "/usr/local/bin",
  data .. "/mason/bin",
  vim.env.PATH or "",
}, ":")
require("config.treesitter_cli").prepend_to_path(data)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Neovim 0.9.x: vim.fs.joinpath exists from 0.10; nvim-treesitter calls it in setup.
if vim.fs and not vim.fs.joinpath then
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.fs.joinpath = function(...)
    local parts = { ... }
    if #parts == 0 then
      return ""
    end
    local acc = tostring(parts[1]):gsub("/+$", "")
    for i = 2, #parts do
      local p = tostring(parts[i]):gsub("^/+", ""):gsub("/+$", "")
      if p ~= "" then
        acc = acc .. "/" .. p
      end
    end
    return acc
  end
end

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
