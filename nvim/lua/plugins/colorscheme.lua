return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = { light = "latte", dark = "mocha" },
        integrations = {
          cmp = true,
          nvimtree = true,
          treesitter = true,
          mason = true,
        },
      })
      vim.opt.background = "dark"
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
