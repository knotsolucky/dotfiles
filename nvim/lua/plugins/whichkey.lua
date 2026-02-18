local icons = require("icons")

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      ---@type false | "classic" | "modern" | "helix"
      preset = "helix",
      delay = function(ctx)
        return ctx.plugin and 0 or 200
      end,
      icons = {
        breadcrumb = "»",
        separator = " ",
        group = "+",
      },
      win = {
        border = "rounded",
        padding = { 2, 3 },
      },
      spec = {
        { "  ", group = "Find files (home)", icon = { icon = icons.search, color = "purple" } },
        -- Explorer
        { " e", group = "Explorer", icon = { icon = icons.folder, color = "blue" } },
        -- Buffers
        { " b", group = "Buffers", icon = { icon = icons.columns, color = "yellow" } },
        { " b n", group = "Next buffer", icon = { icon = icons.columns, color = "yellow" } },
        { " b p", group = "Previous buffer", icon = { icon = icons.columns, color = "yellow" } },
        { " b d", group = "Close buffer", icon = { icon = icons.columns, color = "yellow" } },
        -- Telescope
        { " f", group = "Telescope", icon = { icon = icons.search, color = "purple" } },
        { " f f", group = "Find files", icon = { icon = icons.search, color = "purple" } },
        { " f r", group = "Recent files", icon = { icon = icons.search, color = "purple" } },
        { " f g", group = "Live grep", icon = { icon = icons.search, color = "purple" } },
        { " f b", group = "Buffers", icon = { icon = icons.search, color = "purple" } },
        { " f h", group = "Help tags", icon = { icon = icons.search, color = "purple" } },
        { " f y", group = "Resume", icon = { icon = icons.search, color = "purple" } },
        -- Code
        { " c", group = "Code", icon = { icon = icons.code, color = "green" } },
        -- Git
        { " g", group = "Git", icon = { icon = icons.github, color = "orange" } },
        -- File
        { " w", group = "Save", icon = { icon = icons.save, color = "cyan" } },
        -- Quit
        { " q", group = "Quit", icon = { icon = icons.times, color = "red" } },
        -- Transparency + Theme
        { " t", group = "Transparency", icon = { icon = icons.adjust, color = "cyan" } },
        { " t t", group = "Transparency mode", icon = { icon = icons.adjust, color = "cyan" } },
        { " t h", group = "Theme switcher", icon = { icon = icons.theme, color = "cyan" } },
        -- Dashboard
        { " d", group = "Dashboard", icon = { icon = icons.dashboard, color = "blue" } },
        -- Session
        { " s", group = "Session", icon = { icon = icons.session, color = "green" } },
        { " s s", group = "Sessions", icon = { icon = icons.session, color = "green" } },
      },
    },
  },
}
