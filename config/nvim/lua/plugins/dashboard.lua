return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    priority = 900,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local dash = require("alpha.themes.dashboard")
      local button = dash.button

      -- Default theme shows SPC f h / SPC f r etc.; leader here is space, and fh is help in this config — wrong targets.
      dash.section.buttons.val = {
        button("e", "  New file", "<cmd>ene<bar>startinsert<cr>"),
        button("f", "󰈞  Find file", "<cmd>lua require('telescope.builtin').find_files()<cr>"),
        button("g", "󰈬  Grep", "<cmd>lua require('telescope.builtin').live_grep()<cr>"),
        button("o", "  Recent", "<cmd>lua require('telescope.builtin').oldfiles()<cr>"),
        button("b", "󰓩  Buffers", "<cmd>lua require('telescope.builtin').buffers()<cr>"),
        button("h", "󰋖  Help", "<cmd>lua require('telescope.builtin').help_tags()<cr>"),
        button("x", "󰁪  Diagnostics", "<cmd>lua require('telescope.builtin').diagnostics()<cr>"),
        button("m", "󰏖  Mason", "<cmd>Mason<cr>"),
        button("q", "󰅙  Quit", "<cmd>qa<cr>"),
      }

      require("alpha").setup(dash.config)
    end,
  },
}
