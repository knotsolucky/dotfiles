return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
    },
    config = function() require("configs.cmp") end,
  },
  { "L3MON4D3/LuaSnip", lazy = false, opts = {} },
}
