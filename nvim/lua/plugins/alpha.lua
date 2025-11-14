return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        " ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        " ████╗  ██║██║   ██║██║████╗ ████║",
        " ██╔██╗ ██║██║   ██║██║██╔████╔██║",
        " ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        " ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("g", "  Live grep", ":Telescope live_grep<CR>"),
        dashboard.button("n", "  New file", ":ene <BAR> startinsert<CR>"),
        dashboard.button("e", "  Explorer", ":NvimTreeToggle<CR>"),
        dashboard.button("u", "  Update plugins", ":Lazy sync<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      dashboard.section.footer.val = "Neovim loaded " .. vim.fn.strftime("%A, %d %B %Y")

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
    end,
  },
}


