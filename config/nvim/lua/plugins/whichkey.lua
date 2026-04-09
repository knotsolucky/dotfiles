return {
  {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
      require("which-key").setup({
        preset = "helix",
        layout = { width = { min = 28, max = 60 } },
        spec = {
          { " f", group = "Telescope", desc = "Telescope" },
          { " c", group = "\u{eb64} LSP", desc = "LSP" },
          { " e", group = "\u{f07b} Explorer", desc = "Explorer" },
          { " t", group = "Tabs", desc = "Tabs" },
          { " l", group = "\u{f071} Show all linter messages", desc = "Show all linter messages" },
          { " ?", group = "\u{f11c} Which-key", desc = "Show keymaps" },
        },
      })
    end,
  },
}
