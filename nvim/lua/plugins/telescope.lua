return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("configs.telescope") end,
  },
}
