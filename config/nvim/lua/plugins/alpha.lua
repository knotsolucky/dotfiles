return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "",
        "+----------------------------------------+",
        "|               luckyvim                 |",
        "+----------------------------------------+",
        "",
      }
      dashboard.section.buttons.val = {
        dashboard.button("e", "New file", ":ene <BAR> startinsert<CR>"),
        dashboard.button("f", "Files", ":Ex<CR>"),
        dashboard.button("q", "Quit", ":qa<CR>"),
      }
      require("alpha").setup(dashboard.opts)
    end,
  },
}
