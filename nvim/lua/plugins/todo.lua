return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "BufReadPost",
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
    { "<leader>tt", "<cmd>TodoTelescope<cr>", desc = "Todo (Telescope)" },
    { "<leader>tq", "<cmd>TodoQuickFix<cr>", desc = "Todo (quickfix)" },
    { "<leader>tl", "<cmd>TodoLocList<cr>", desc = "Todo (loclist)" },
  },
  opts = {},
}
