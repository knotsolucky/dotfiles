local o = vim.opt

-- Use a Nerd Font so icons render consistently (GUI). In terminal, set your terminal font to the same.
o.guifont = "JetBrainsMono Nerd Font:h14"

o.number = true
o.relativenumber = true
o.mouse = "a"
o.signcolumn = "yes"
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.wrap = false
o.ignorecase = true
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.smartindent = true
o.pumheight = 10

vim.filetype.add({
  extension = { ts = "typescript", tsx = "typescriptreact", js = "javascript", jsx = "javascriptreact" },
})

local icons = require("icons")
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostic_error,
      [vim.diagnostic.severity.WARN] = icons.diagnostic_warn,
      [vim.diagnostic.severity.INFO] = icons.diagnostic_info,
      [vim.diagnostic.severity.HINT] = icons.diagnostic_hint,
    },
  },
  virtual_text = {
    prefix = " ",
    format = function(d) return d.message end,
  },
})
