--- Peek LSP locations in a floating window without jumping.
local M = {}

local function open_peek_float(location)
  if not location then return end
  local uri = location.uri or location.targetUri
  if not uri then return end
  local path = vim.uri_to_fname(uri)
  local range = location.range or location.targetRange or location.targetSelectionRange
  if not range then return end
  local start_line = range.start.line
  local end_line = range["end"].line
  local lines = vim.fn.readfile(path, "", end_line + 1)
  if #lines == 0 then return end
  local slice = {}
  for i = start_line + 1, math.min(end_line + 1, #lines) do
    slice[#slice + 1] = lines[i]
  end
  if #slice == 0 then slice = { lines[start_line + 1] or "" } end

  local width = math.min(80, vim.opt.columns:get() - 4)
  local height = math.min(15, #slice + 2)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, slice)
  vim.bo[buf].filetype = vim.filetype.match({ filename = path }) or "text"
  vim.bo[buf].bufhidden = "wipe"

  local row = math.floor((vim.opt.lines:get() - height) / 2) - 1
  local col = math.floor((vim.opt.columns:get() - width) / 2)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].wrap = false
  local close = function() vim.api.nvim_win_close(win, true) end
  vim.keymap.set("n", "q", close, { buffer = buf })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf })
  vim.keymap.set("n", "<C-c>", close, { buffer = buf })
  vim.keymap.set("n", "<CR>", function()
    vim.api.nvim_win_close(win, true)
    vim.cmd.edit(path)
    vim.api.nvim_win_set_cursor(0, { start_line + 1, range.start.character })
  end, { buffer = buf })
end

local function peek_request(method, cb)
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, method, params, function(err, result, _ctx)
    if err or not result then return end
    local loc = result
    if type(result) == "table" and result[1] then
      loc = result[1]
    end
    if loc then open_peek_float(loc) end
    if cb then cb() end
  end)
end

function M.peek_definition()
  peek_request("textDocument/definition")
end

function M.peek_references()
  peek_request("textDocument/references", function() end)
end

function M.peek_implementations()
  peek_request("textDocument/implementation")
end

return M
