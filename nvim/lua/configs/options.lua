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

vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  underline = false,
})
