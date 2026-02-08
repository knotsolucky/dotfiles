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
            i = {
              ["<C-t>"] = actions.select_tab, -- open selection in a new tab
            },
            n = {
              ["<C-t>"] = actions.select_tab, -- open selection in a new tab
            },
          },
        },
      }
      local ok = pcall(require("telescope").load_extension, "fzf")
      if not ok then
        vim.notify(
          "telescope-fzf-native: run `make` in ~/.local/share/nvim/lazy/telescope-fzf-native.nvim to build libfzf.so",
          vim.log.levels.WARN
        )
      end
    end,
  },
}
