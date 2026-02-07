return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = { border = true, borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" } },
      })
    end,
  },
}
