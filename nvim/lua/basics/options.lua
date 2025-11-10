local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.netrw_liststyle = 3

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"

opt.wrap = false
opt.scrolloff = 6
opt.sidescrolloff = 8

opt.expandtab = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.autoindent = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

opt.splitbelow = true
opt.splitright = true

opt.swapfile = false
opt.undofile = true

opt.updatetime = 200
opt.timeoutlen = 400

opt.fillchars = { eob = " " }
opt.list = true
opt.listchars = { tab = "» ", trail = "·" }
