return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "dap" },
        { "<leader>l", group = "lint" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>g", group = "git" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Which-key",
      },
    },
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
}
