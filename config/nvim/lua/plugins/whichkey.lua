return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer local keymaps",
      },
    },
    opts = {
      preset = "classic",
      delay = 300,
      icons = { mappings = false },
      win = { border = "rounded" },
    },
  },
}
