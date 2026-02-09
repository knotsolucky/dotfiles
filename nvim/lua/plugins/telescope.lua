return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local actions = require "telescope.actions"

      require("telescope").setup {
        defaults = {
          border = true,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          mappings = {
            i = { ["<C-t>"] = actions.select_tab },
            n = { ["<C-t>"] = actions.select_tab },
          },
        },
      }
      if not pcall(require("telescope").load_extension, "fzf") then
        vim.notify("telescope-fzf-native: run `make` in plugin dir", vim.log.levels.WARN)
      end
    end,
  },
}
