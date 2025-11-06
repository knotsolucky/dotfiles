-- Make create a variable to shorten the code
local opt = vim.opt
local g = vim.g
local cmd = vim.cmd

cmd("let g:netrw_liststyle = 3")

opt.number = true
opt.relativenumber = true
opt.undofile = true
g.mapleader = " "

extendtab = true
opt.tabstop = 4
opt.autoindent = true
opt.shiftwidth = 0
opt.cursorline = true

vim.opt.fillchars:append({ eob = " " })  -- hide ~ at end of buffer

