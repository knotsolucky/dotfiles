local o = vim.opt
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

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅙",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.INFO] = "󰋼",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
  virtual_text = {
    prefix = " ",
    format = function(d) return d.message end,
  },
})
