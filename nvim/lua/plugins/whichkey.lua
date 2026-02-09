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
        { " e", group = "Explorer", icon = { icon = "\239\129\187", color = "blue" } },
        { " b", group = "Buffers", icon = { icon = "\239\134\178", color = "yellow" } },
        { " f", group = "Telescope", icon = { icon = "\239\128\130", color = "purple" } },
        { " c", group = "Code", icon = { icon = "\239\132\161", color = "green" } },
        { " d", group = "Debug", icon = { icon = "\239\163\169", color = "magenta" } },
        { " g", group = "Git", icon = { icon = "\239\132\166", color = "orange" } },
        { " w", group = "File", icon = { icon = "\239\131\135", color = "cyan" } },
        { " q", group = "Quit", icon = { icon = "\239\128\141", color = "red" } },
      },
    },
  },
}
