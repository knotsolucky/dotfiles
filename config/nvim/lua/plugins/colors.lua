---@return "dark"|"light"
local function appearance_mode()
  local path = vim.fn.expand("~/.local/state/appearance-mode")
  local ok, lines = pcall(vim.fn.readfile, path, "", 1)
  if not ok or type(lines) ~= "table" or not lines[1] then
    return "dark"
  end
  local v = vim.trim(tostring(lines[1]))
  if v == "light" then
    return "light"
  end
  return "dark"
end

local mode = appearance_mode()

return {
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
    config = function()
      if mode == "light" then
        vim.o.background = "light"
        vim.cmd.colorscheme("habamax")
        return
      end
      vim.o.background = "dark"
      vim.cmd.colorscheme("moonfly")
    end,
  },
}
