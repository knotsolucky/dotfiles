vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.updatetime = 250

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
-- Neovim 0.11+: default border for floats (LSP hovers, etc.) when plugins don’t override
if vim.fn.has("nvim-0.11") == 1 then
  vim.o.winborder = "rounded"
end
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 4
vim.opt.fillchars:append({ eob = " " })

-- Full diagnostic text: default virtual_text is easy to read as severity-only; virtual_lines
-- (0.11+) shows the whole message under the cursor line. Float uses source + message.
local diag = {
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    header = "",
    source = false,
    format = function(d)
      local src = d.source and ("[" .. d.source .. "] ") or ""
      return src .. d.message
    end,
  },
}

if vim.fn.has("nvim-0.11") == 1 then
  diag.virtual_text = false
  diag.virtual_lines = { current_line = true }
else
  diag.virtual_text = {
    spacing = 6,
    source = true,
    prefix = "",
  }
end

vim.diagnostic.config(diag)
