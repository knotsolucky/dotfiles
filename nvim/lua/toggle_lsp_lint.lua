local state_path = vim.fn.stdpath("state") .. "/lsp_lint_formatter_disabled"

local function load_state()
  local ok, lines = pcall(vim.fn.readfile, state_path)
  if ok and #lines > 0 and (lines[1] == "1" or lines[1] == "true") then
    return true
  end
  return false
end

local function save_state(disabled)
  local dir = vim.fn.fnamemodify(state_path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  vim.fn.writefile({ disabled and "1" or "0" }, state_path)
end

vim.g.disable_lsp_lint_formatter = load_state()
if vim.g.disable_lsp_lint_formatter then
  vim.diagnostic.disable()
end

local function toggle()
  vim.g.disable_lsp_lint_formatter = not vim.g.disable_lsp_lint_formatter
  save_state(vim.g.disable_lsp_lint_formatter)
  if vim.g.disable_lsp_lint_formatter then
    vim.diagnostic.disable()
    vim.notify("LSP / Lint / Formatter off", vim.log.levels.INFO, { title = "Toggle" })
  else
    vim.diagnostic.enable()
    vim.notify("LSP / Lint / Formatter on", vim.log.levels.INFO, { title = "Toggle" })
  end
end

vim.api.nvim_create_user_command("ToggleLSPLintFormatter", toggle, {})
