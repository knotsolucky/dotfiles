return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { marks = true, registers = true, spelling = { enabled = true, suggestions = 20 } },
      win = { border = "single" },
      layout = { spacing = 6 },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Debug" },
        { "<leader>db", desc = "Toggle breakpoint" },
        { "<leader>dB", desc = "Conditional breakpoint" },
        { "<leader>dr", desc = "Toggle REPL" },
        { "<leader>dl", desc = "Run last" },
        { "<leader>du", desc = "Toggle DAP UI" },
        { "<leader>f", group = "Find" },
        { "<leader>ff", desc = "Find files" },
        { "<leader>fg", desc = "Live grep" },
        { "<leader>fb", desc = "Buffers" },
        { "<leader>fh", desc = "Help tags" },
        { "<leader>e", desc = "Toggle explorer" },
        { "<leader>E", desc = "Focus explorer" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
      }, { mode = "n" })
    end,
  },
}
