return {
  "zaldih/themery.nvim",
  lazy = false,
  priority = 999, -- after nightfox (1000)
  dependencies = {
    "EdenEast/nightfox.nvim",
    "folke/tokyonight.nvim",
    "catppuccin/nvim",
  },
  opts = {
    themes = {
      -- Nightfox
      { name = "Carbonfox", colorscheme = "carbonfox" },
      { name = "Nightfox", colorscheme = "nightfox" },
      { name = "Dayfox", colorscheme = "dayfox" },
      { name = "Dawnfox", colorscheme = "dawnfox" },
      { name = "Nordfox", colorscheme = "nordfox" },
      { name = "Terafox", colorscheme = "terafox" },
      -- Tokyo Night
      { name = "Tokyo Night", colorscheme = "tokyonight" },
      { name = "Tokyo Night Storm", colorscheme = "tokyonight-storm" },
      { name = "Tokyo Night Day", colorscheme = "tokyonight-day" },
      { name = "Tokyo Night Moon", colorscheme = "tokyonight-moon" },
      -- Catppuccin
      { name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
      { name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
      { name = "Catppuccin Frappe", colorscheme = "catppuccin-frappe" },
      { name = "Catppuccin Latte", colorscheme = "catppuccin-latte" },
    },
    livePreview = true,
  },
  config = function(_, opts)
    require("themery").setup(opts)
    -- Ensure a theme is always applied: loadState runs in bootstrap; if no saved theme, set default
    vim.schedule(function()
      if not vim.g.colors_name or vim.g.colors_name == "" then
        vim.cmd.colorscheme(opts.themes[1].colorscheme)
      end
    end)
  end,
}
