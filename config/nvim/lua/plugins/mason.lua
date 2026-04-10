return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
}
