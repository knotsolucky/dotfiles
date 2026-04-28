return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "  _   _       _         ",
        " | \\ | | ___ | |__  ___ ",
        " |  \\| |/ _ \\| '_ \\/ __|",
        " | |\\  | (_) | | | \\__ \\",
        " |_| \\_|\\___/|_| |_|___/",
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
