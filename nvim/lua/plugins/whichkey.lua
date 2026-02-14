return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = function(ctx) return ctx.plugin and 0 or 200 end,
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
        { "  ", group = "Find (home)", icon = { icon = "\239\128\130", color = "purple" } },
        { " e", group = "Explorer", icon = { icon = "\239\129\187", color = "blue" } },
        { " b", group = "Buffers", icon = { icon = "\239\134\178", color = "yellow" } },
        { " f", group = "Telescope", icon = { icon = "\239\128\130", color = "purple" } },
        { " c", group = "Code", icon = { icon = "\239\132\161", color = "green" } },
        { " t", group = "Todo", icon = { icon = "\239\145\139", color = "yellow" } },
        { " m", group = "Markdown", icon = { icon = "\239\144\132", color = "blue" } },
        { " F", group = "Markdown", icon = { icon = "\239\144\132", color = "blue" } },
        { " p", group = "Markdown", icon = { icon = "\239\144\132", color = "blue" } },
        { " d", group = "Debug", icon = { icon = "\239\163\169", color = "magenta" } },
        { " g", group = "Git", icon = { icon = "\239\132\166", color = "orange" } },
        { " w", group = "File", icon = { icon = "\239\131\135", color = "cyan" } },
        { " q", group = "Quit", icon = { icon = "\239\128\141", color = "red" } },
        { " a", group = "Actions", icon = { icon = "\239\132\161", color = "green" } },
        { " i", group = "Info", icon = { icon = "\239\129\156", color = "cyan" } },
        { " n", group = "Next", icon = { icon = "\239\134\178", color = "yellow" } },
      },
    },
  },
}
