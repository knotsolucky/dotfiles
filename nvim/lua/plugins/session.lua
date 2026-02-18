return {
  "olimorris/persisted.nvim",
  event = "BufReadPre",
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {
    should_save = function()
      if vim.bo.filetype == "alpha" then
        return false
      end
      return true
    end,
  },
  config = function(_, opts)
    local persisted = require("persisted")
    persisted.setup(opts)
    require("telescope").load_extension("persisted")
  end,
}
