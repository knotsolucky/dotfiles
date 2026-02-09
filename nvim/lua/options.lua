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

local sev = vim.diagnostic.severity
vim.diagnostic.config({
  signs = { text = { [sev.ERROR] = "󰅙", [sev.WARN] = "󰀪", [sev.INFO] = "󰋼", [sev.HINT] = "󰌵" } },
  virtual_text = { prefix = " ", format = function(d) return d.message end },
  float = false,
})

local function hover_in_split(_, result, _, _)
  if not result or not result.contents then return end
  local content = result.contents
  if type(content) == "table" then
    content = content.value or (content[1] and content[1].value) or ""
  end
  if type(content) ~= "string" or content == "" then return end
  vim.cmd("belowright split")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, vim.split(content, "\n"))
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_win_set_option(0, "wrap", true)
  vim.api.nvim_win_set_option(0, "number", false)
  vim.api.nvim_win_set_option(0, "relativenumber", false)
end

vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_hover] = vim.lsp.with(hover_in_split, {})
