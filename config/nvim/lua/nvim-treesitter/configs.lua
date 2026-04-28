local M = {}

function M.setup(opts)
  return require("nvim-treesitter").setup(opts)
end

return M
