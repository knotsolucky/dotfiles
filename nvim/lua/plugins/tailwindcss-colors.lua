return {
  {
    "themaxmarchuk/tailwindcss-colors.nvim",
    lazy = false,
    opts = {},
    config = function(_, opts) require("tailwindcss-colors").setup(opts) end,
  },
}
